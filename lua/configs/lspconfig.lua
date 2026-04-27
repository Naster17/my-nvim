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
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
})
vim.lsp.enable "ts_ls"

-- JSON
vim.lsp.config("jsonls", {
  capabilities = capabilities,
})
vim.lsp.enable "jsonls"

vim.lsp.enable "clangd"
vim.lsp.enable "rust_analyzer"
vim.lsp.enable "qmlls"

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
vim.lsp.enable "lua_ls"

require("mason").setup()

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    local ok, registry = pcall(require, "mason-registry")
    if not ok then
      return
    end

    registry.refresh(function()
      for _, name in ipairs(require("nvconfig").mason.pkgs or {}) do
        local pkg_ok, pkg = pcall(registry.get_package, name)

        if pkg_ok and not pkg:is_installed() then
          pkg:install()
        end
      end
    end)
  end,
})

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
