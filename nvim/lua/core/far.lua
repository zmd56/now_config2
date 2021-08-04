local vim = vim
local cmd = vim.cmd
local api = vim.api

vim.g.far_enable_undo = 1
cmd("set lazyredraw")
cmd("set regexpengine=1")
cmd("set ignorecase smartcase")

api.nvim_set_keymap("n", "<Find-Shortcut>", ":Farf<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("v", "<Find-Shortcut>", ":Farf<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<Find-Shortcut>", ":Farr<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("v", "<Find-Shortcut>", ":Farr<CR>", { noremap = true, silent = true })
