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
          return require("codecompanion.adapters").extend("openai_compatible", {
            formatted_name = "llama.cpp",
            env = {
              url = vim.env.LLAMA_CPP_URL or "http://127.0.0.1:8080",
              api_key = "llama-cpp",
            },
            schema = {
              model = {
                default = "llama-cpp",
                choices = { "llama-cpp" },
              },
            },
            handlers = {
              form_messages = function(self, messages)
                local openai = require "codecompanion.adapters.http.openai"
                local adapter_utils = require "codecompanion.adapters.utils"
                return openai.handlers.form_messages(self, adapter_utils.merge_system_messages(messages))
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
