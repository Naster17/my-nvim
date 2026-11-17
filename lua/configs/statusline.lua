local M = {}

local function format_tokens(count)
  if count >= 1000 then
    return string.format("%.1fk", count / 1000)
  end
  return tostring(count)
end

local function current_bufnr()
  local winid = tonumber(vim.g.statusline_winid) or vim.api.nvim_get_current_win()
  local ok, bufnr = pcall(vim.api.nvim_win_get_buf, winid)
  return ok and bufnr or nil
end

---Statusline segment for the current CodeCompanion chat buffer
---@return string
function M.codecompanion()
  local bufnr = current_bufnr()
  local metadata = bufnr and _G.codecompanion_chat_metadata and _G.codecompanion_chat_metadata[bufnr]
  if not metadata then
    return ""
  end

  local chat = require("codecompanion").buf_get_chat(bufnr)
  local parts = { metadata.adapter.name or metadata.adapter.model }

  local model_meta = chat and chat.adapter and chat.adapter.model and chat.adapter.model.meta
  local context_window = model_meta and model_meta.context_window
  if context_window and metadata.tokens and metadata.tokens > 0 then
    table.insert(parts, string.format("%d%%%%", math.floor(metadata.tokens / context_window * 100)))
  end

  local rules_tokens = 0
  for _, message in ipairs(chat and chat.messages or {}) do
    if message._meta and message._meta.tag == "rules" then
      rules_tokens = rules_tokens
        + (message._meta.estimated_tokens or require("codecompanion.utils.tokens").calculate(message.content or ""))
    end
  end
  if rules_tokens > 0 then
    table.insert(parts, "rules " .. format_tokens(rules_tokens))
  end

  local settings = chat and chat.settings
  if settings then
    if settings.reasoning_budget_tokens ~= nil then
      table.insert(parts, "think " .. settings.reasoning_budget_tokens)
    elseif settings.reasoning_effort then
      table.insert(parts, "effort " .. settings.reasoning_effort)
    end
  end

  if metadata.tools and metadata.tools > 0 then
    table.insert(parts, metadata.tools .. " tools")
  end

  return "%#St_Lsp# " .. table.concat(parts, " · ") .. " "
end

return M
