require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "v" }, "<leader>ai", ":CodeCompanion<CR>", { desc = "CodeCompanion inline" })
map("n", "<leader>ar", "<cmd>CodeCompanionCodeReview<cr>", { desc = "CodeCompanion code review" })

-- Antigay
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
