local saga = require("lspsaga")
local vim = vim

saga.init_lsp_saga({
	use_saga_diagnostic_sign = true,
	error_sign = "",
	warn_sign = "",
	hint_sign = "",
	infor_sign = "",
	dianostic_header_icon = "   ",
	code_action_icon = " ",
	code_action_prompt = {
		enable = true,
		sign = true,
		sign_priority = 20,
		virtual_text = true,
	},
	finder_definition_icon = "  ",
	finder_reference_icon = "  ",
	max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
	finder_action_keys = {
		open = "o",
		vsplit = "s",
		split = "i",
		quit = "q",
		scroll_down = "<C-f>",
		scroll_up = "<C-b>", -- quit can be a table
	},
	code_action_keys = {
		quit = "q",
		exec = "<CR>",
	},
	rename_action_keys = {
		quit = "<C-c>",
		exec = "<CR>", -- quit can be a table
	},
	definition_preview_icon = "  ",
	-- "single" "double" "round" "plus"
	border_style = "single",
	rename_prompt_prefix = "➤",
	-- if you don't use nvim-lspconfig you must pass your server name and
	-- the related filetypes into this table
	-- like server_filetype_map = {metals = {'sbt', 'scala'}}
	server_filetype_map = {},
})

-- LSP: lsp_finder
vim.api.nvim_set_keymap("n", "gf", "<cmd>lua require('lspsaga.provider').lsp_finder()<CR>", {
	silent = true,
})
-- LSP: lsp preview definition
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua require('lspsaga.provider').preview_definition()<CR>", {
	silent = true,
})

-- LSP: code actions
vim.api.nvim_set_keymap("n", "ga", "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", {
	silent = true,
})

vim.api.nvim_set_keymap("v", "ga", "<cmd><C-U>lua require('lspsaga.codeaction').range_code_action()<CR>", {
	silent = true,
})

-- LSP: hover doc
vim.api.nvim_set_keymap("n", "gh", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", {
	silent = true,
})

-- LSP: scroll
vim.api.nvim_set_keymap("n", "<C-j>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", {
	silent = true,
})

vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", {
	silent = true,
})

-- LSP: SignatureHelp
vim.api.nvim_set_keymap("n", "gs", "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", {
	silent = true,
})

-- LSP: rename
vim.api.nvim_set_keymap("n", "gr", "<cmd>lua require('lspsaga.rename').rename()<CR>", {
	silent = true,
})

-- LSP: Diagnostic
vim.api.nvim_set_keymap("n", "gl", "<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>", {
	silent = true,
})

vim.api.nvim_set_keymap("n", "gu", "<cmd>lua require('lspsaga.diagnostic').show_cursor_diagnostics()<CR>", {
	silent = true,
})

vim.api.nvim_set_keymap("n", "gm", "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>", {
	silent = true,
})

vim.api.nvim_set_keymap("n", "gn", "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>", {
	silent = true,
})
