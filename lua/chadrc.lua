-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "material-deep-ocean",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

M.mason = {
  pkgs = {
    "stylua",
    "prettier",
    "html-lsp",
    "css-lsp",
    "json-lsp",
    "lua-language-server",
    "codelldb",
    "rust-analyzer",
    "clangd",
    "clang-format",
    "python-lsp-server",
    "typescript-language-server",
  },
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
--}

return M
