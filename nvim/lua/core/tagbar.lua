local g = vim.g

vim.api.nvim_set_keymap("n", "<F2>", ":TagbarToggle<CR>", { noremap = true, silent = true })
g.tagbar_autoclose = 1
g.tagbar_width = 30
g.tagbar_left = 1
g.tagbar_sort = 0
g.tagbar_case_insensitive = 0
g.tagbar_compact = 1
g.tagbar_show_balloon = 0
g.tagbar_show_data_type = 0
g.tagbar_show_linenumbers = 2
g.tagbar_show_tag_count = 1
g.tagbar_autopreview = 0
g.tagbar_indent = 0
g.tagbar_iconchars = { "▶", "▼" }
