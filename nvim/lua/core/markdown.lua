local vim = vim
local g = vim.g
local api = vim.api

g.mkdp_auto_start = 0
g.mkdp_auto_close = 1
g.mkdp_refresh_slow = 0
g.mkdp_command_for_global = 0
g.mkdp_open_to_the_world = 0
g.mkdp_open_ip = ""
g.mkdp_browser = "chromium"
g.mkdp_echo_preview_url = 0
g.mkdp_browserfunc = ""
api.nvim_exec(
	[[
  let g:mkdp_preview_options = {'mkit': {},'katex': {},'uml': {},'maid': {},'disable_sync_scroll': 0,'sync_scroll_type': 'middle','hide_yaml_meta': 1,'sequence_diagrams': {},'flowchart_diagrams': {},'content_editable': v:false,'disable_filename': 0}
]],
	false
)
g.mkdp_markdown_css = ""
g.mkdp_highlight_css = ""
g.mkdp_port = ""
g.mkdp_page_title = "「${name}」"
g.mkdp_filetypes = { "markdown" }

-- vim-table-mode
api.nvim_set_keymap("n", "<leader>tm", ":TableModeToggle<CR>", { noremap = true })
g.table_mode_cell_text_object_i_map = "k<Bar>"
g.table_mode_corner_corner = "+"
g.table_mode_header_fillchar = "="

-- vim-markdown-toc
g.vmt_cycle_list_item_markers = 1
g.vmt_fence_text = "TOC"
g.vmt_fence_closing_text = "/TOC"

-- Bullets.vim
g.bullets_enabled_file_types = { "markdown", "text", "gitcommit", "scratch" }
