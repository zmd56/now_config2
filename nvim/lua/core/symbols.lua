local vim = vim

-- 打开大纲
vim.api.nvim_set_keymap("n", "<F2>", "<cmd>SymbolsOutline<cr>", { silent = true })

vim.g.symbols_outline = {
	highlight_hovered_item = true,
	show_guides = true,
	auto_preview = false,
	position = "left",
	show_numbers = false,
	show_relative_numbers = false,
	show_symbol_details = true,
	keymaps = {
		close = "<Esc>",
		goto_location = "<Cr>",
		focus_location = "o",
		hover_symbol = "p",
		rename_symbol = "r",
		code_actions = "a",
	},
	lsp_blacklist = {},
}
