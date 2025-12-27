require "nvchad.options"

-- add yours here!
local opt = vim.opt

opt.number = true
opt.relativenumber = true

-- opt.clipboard:append "unnamedplus" -- use system clipboard
opt.clipboard = 'unnamedplus'

opt.ignorecase = true
opt.smartcase = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true

vim.o.cursorline = true

vim.o.scrolloff = 10

vim.o.list = true

vim.o.confirm = true

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
