-- Users: change this to your llama.cpp server, or set LLAMA_CPP_URL
local DEFAULT_LLAMA_URL = "http://bc250.int:8080"

local function llama_url()
  return (vim.env.LLAMA_CPP_URL or DEFAULT_LLAMA_URL):gsub("/+$", "")
end

local models_cache = { at = 0, choices = nil }

---Models the llama.cpp server reports, with their context metadata
---@return table<string, table>|nil
local function fetch_llama_models()
  local now = vim.uv.now()
  if models_cache.choices and now - models_cache.at < 30000 then
    return models_cache.choices
  end

  local body = vim.fn.system { "curl", "-sS", "--max-time", "2", llama_url() .. "/v1/models" }
  if vim.v.shell_error ~= 0 or body == "" then
    return nil
  end

  local ok, response = pcall(vim.json.decode, body)
  if not ok or type(response) ~= "table" or type(response.data) ~= "table" then
    return nil
  end

  local context_override = tonumber(vim.env.LLAMA_CPP_CONTEXT_WINDOW)
  local choices = {}
  for _, model in ipairs(response.data) do
    local id = model.id
    if type(id) == "string" and id ~= "" then
      local n_ctx = model.meta and tonumber(model.meta.n_ctx)
      local context_window = context_override or n_ctx
      choices[id] = {
        formatted_name = (id:match("([^/\\]+)$") or id):gsub("%.gguf$", ""),
        meta = context_window and { context_window = context_window } or nil,
      }
    end
  end

  if vim.tbl_isempty(choices) then
    return nil
  end

  models_cache = { at = now, choices = choices }
  return choices
end

---Model to start chats with: explicit env, server's first model, or a generic name
---@param choices table<string, table>
---@return string
local function default_llama_model(choices)
  local configured = vim.env.LLAMA_CPP_MODEL
  if configured and configured ~= "" then
    return configured
  end

  local ids = vim.tbl_keys(choices)
  table.sort(ids)
  return ids[1] or "llama-cpp"
end

---Read llama.cpp's /props to learn which reasoning efforts the loaded chat template renders
---@return table|nil
local function fetch_llama_props()
  local body = vim.fn.system { "curl", "-sS", "--max-time", "2", llama_url() .. "/props" }
  if vim.v.shell_error ~= 0 or body == "" then
    return nil
  end

  local ok, props = pcall(vim.json.decode, body)
  return ok and props or nil
end

---Which effort levels the loaded llama.cpp chat template actually renders
---@return { levels: string[], supports_effort: boolean }
local function llama_reasoning_caps()
  local props = fetch_llama_props()
  local caps = props and props.chat_template_caps

  if not caps then
    return { levels = { "minimal", "low", "medium", "high" }, supports_effort = true }
  end

  local levels = caps.reasoning_effort_levels or {}
  return { levels = levels, supports_effort = caps.supports_reasoning_effort == true and #levels > 0 }
end

---Reasoning efforts to offer, taken from llama.cpp's template capabilities
---@return string[]
local function reasoning_efforts()
  local caps = llama_reasoning_caps()
  local efforts = { "none" }
  if caps.supports_effort then
    vim.list_extend(efforts, caps.levels)
  end
  return efforts
end

---Pick the reasoning effort for the current llama.cpp chat
---@param chat CodeCompanion.Chat
---@return nil
local function select_reasoning_effort(chat)
  if chat.adapter.name ~= "llama_cpp" then
    return vim.notify("Reasoning effort is only configured for llama.cpp", vim.log.levels.WARN)
  end

  local caps = llama_reasoning_caps()
  local items = { { label = "default (template)" } }

  if caps.supports_effort then
    table.insert(items, { label = "none", effort = "none", budget = 0 })
    for _, level in ipairs(caps.levels) do
      table.insert(items, { label = level, effort = level })
    end
  else
    -- The template ignores reasoning_effort, so llama.cpp's per-request token budget is the only lever
    table.insert(items, { label = "off", effort = "none", budget = 0 })
    table.insert(items, { label = "low", budget = 128 })
    table.insert(items, { label = "medium", budget = 512 })
    table.insert(items, { label = "high", budget = 2048 })
  end

  local current = chat.settings or {}
  local labels = {}
  for _, item in ipairs(items) do
    local selected = item.effort == current.reasoning_effort and item.budget == current.reasoning_budget_tokens
    table.insert(labels, (selected and "* " or "  ") .. item.label)
  end

  vim.ui.select(labels, { prompt = "llama.cpp reasoning effort" }, function(_, index)
    if not index then
      return
    end

    local item = items[index]
    chat.settings = chat.settings or {}
    chat.settings.reasoning_effort = item.effort
    chat.settings.reasoning_budget_tokens = item.budget

    -- map_schema_to_params() only writes non-nil keys, so clear the stale pair here
    if chat.adapter.parameters then
      chat.adapter.parameters.reasoning_effort = item.effort
      chat.adapter.parameters.reasoning_budget_tokens = item.budget
    end

    local note = item.budget and item.budget > 0 and (" (budget " .. item.budget .. ")") or ""
    vim.notify("llama.cpp reasoning effort: " .. item.label .. note, vim.log.levels.INFO)
  end)
end

return {
  "olimorris/codecompanion.nvim",
  version = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "codecompanion" },
      opts = {
        anti_conceal = { enabled = false },
      },
    },
  },
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionCodeReview",
  },
  keys = {
    { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion chat" },
    { "<leader>an", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "CodeCompanion new chat" },
    { "<leader>ap", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion actions" },
    { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add selection to chat" },
  },
  opts = {
    adapters = {
      http = {
        llama_cpp = function()
          local choices = fetch_llama_models() or {}
          local default = default_llama_model(choices)
          if not choices[default] then
            local context_window = tonumber(vim.env.LLAMA_CPP_CONTEXT_WINDOW)
            local only_model = next(choices)
            if not context_window and only_model and not next(choices, only_model) then
              context_window = choices[only_model].meta and choices[only_model].meta.context_window
            end
            choices[default] = {
              formatted_name = default,
              meta = context_window and { context_window = context_window } or nil,
            }
          end

          return require("codecompanion.adapters").extend("openai_compatible", {
            formatted_name = "llama.cpp",
            env = {
              url = llama_url(),
              api_key = "llama-cpp",
            },
            schema = {
              model = {
                default = default,
                choices = choices,
              },
              reasoning_effort = {
                order = 2,
                mapping = "parameters",
                type = "string",
                optional = true,
                desc = "Reasoning effort passed to the llama.cpp chat template. 'none' disables thinking.",
                choices = reasoning_efforts,
              },
              reasoning_budget_tokens = {
                order = 3,
                mapping = "parameters",
                type = "number",
                optional = true,
                desc = "Per-request thinking budget in tokens: 0 disables thinking, -1 is unlimited.",
                validate = function(n)
                  return n >= -1, "Must be -1 or greater"
                end,
              },
            },
            handlers = {
              form_messages = function(self, messages)
                local openai = require "codecompanion.adapters.http.openai_legacy"
                local adapter_utils = require "codecompanion.adapters.utils"
                return openai.handlers.form_messages(self, adapter_utils.merge_system_messages(messages))
              end,
              parse_message_meta = function(self, data)
                local extra = data.extra
                if extra and extra.reasoning_content then
                  data.output.reasoning = { content = extra.reasoning_content }
                  if data.output.content == "" then
                    data.output.content = nil
                  end
                end
                return data
              end,
              form_reasoning = function(self, data)
                local content = vim
                  .iter(data)
                  :map(function(item)
                    return item.content
                  end)
                  :filter(function(item)
                    return item ~= nil
                  end)
                  :join("")
                return { content = content }
              end,
            },
            opts = {
              vision = false,
            },
          })
        end,
      },
    },
    interactions = {
      chat = {
        adapter = "llama_cpp",
        keymaps = {
          reasoning_effort = {
            modes = { n = "gE" },
            callback = select_reasoning_effort,
            description = "Change reasoning effort",
          },
        },
      },
      inline = {
        adapter = "llama_cpp",
      },
    },
    display = {
      chat = {
        window = {
          layout = "vertical",
          position = "right",
          width = 0.30,
          opts = {
            breakindent = true,
            linebreak = true,
            wrap = true,
          },
        },
      },
    },
  },
}
