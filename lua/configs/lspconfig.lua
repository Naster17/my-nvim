-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()
--
-- require('platformio').setup({
--     lsp = "clangd" --default: ccls, other option: clangd
-- })

-- EXAMPLE
-- local lspconfig = require "lspconfig"
-- local servers = { "html", "cssls", "clangd", "pylsp", "cmake", "rust_analyzer", "asm_lsp" }
-- local nvlsp = require "nvchad.configs.lspconfig"
-- for _, lsp in ipairs(servers) do
--     vim.lsp.config(lspconfig[lsp], {
--         on_attach = nvlsp.on_attach,
--         on_init = nvlsp.on_init,
--         capabilities = nvlsp.capabilities,
--     })
-- end

-- vim.lsp.config('clangd', {cmd = {"clangd"}})

--HTML
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config("html", {
  capabilities = capabilities,
})
vim.lsp.enable("html", true)

-- CSS
vim.lsp.config("cssls", {
  capabilities = capabilities,
})
vim.lsp.enable "cssls"

-- JS/TS
vim.lsp.config("typescript", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  capabilities = capabilities,
})
vim.lsp.enable "typescript"

-- JSON
vim.lsp.config("jsonls", {
  capabilities = capabilities,
})
vim.lsp.enable "jsonls"

vim.lsp.enable("clangd", true)
vim.lsp.enable("rust-analyzer", true)
vim.lsp.enable("qmlls", true)

vim.lsp.config("pylsp", {
  settings = {
    pylsp = {
      plugins = {
        flake8 = { maxLineLength = 200 },
        pycodestyle = { maxLineLength = 200 },
      },
    },
  },
})

vim.lsp.enable("pylsp", true)

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = {
          "vim",
          "require",
        },
      },
    },
  },
})

require("mason").setup()
-- Note: `nvim-lspconfig` needs to be in 'runtimepath' by the time you set up mason-lspconfig.nvim
require("mason").setup {
  ensure_installed = {
    "prettier",
    "html-lsp",
    "cssls",
    "json-lsp",
    "lua_ls",
    "codelldb",
    "rust-analyzer",
    "clangd",
    "clang-format",
    "python-lsp-server",
    "typescript-language-server",
  },
}

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
