local vim = vim
local api = vim.api

api.nvim_set_keymap("n", "<A-t>", ":TranslateW<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("v", "<A-t>", ":TranslateW<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<A-r>", ":TranslateR<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("v", "<A-r>", ":TranslateR<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<Leader>x", ":TranslateX<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("v", "<Leader>x", ":TranslateX<CR>", { noremap = true, silent = true })
