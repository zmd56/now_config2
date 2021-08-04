local vim = vim
local g = vim.g
-- vim.api.nvim_set_keymap("n","<A-o>",":RnvimrToggle<CR>",{noremap = true, silent = true})
g.rnvimr_vanilla = 0
g.rnvimr_ex_enable = 0
g.rnvimr_pick_enable = 1
g.rnvimr_bw_enable = 1
g.rnvimr_draw_border = 0
g.rnvim_hide_gitignore = 1
g.rnvimr_border_attr = [['fg':14,'bg': -1]]
g.rnvimr_shadow_winblend = 70
vim.api.nvim_exec(
	[[
  let g:rnvimr_ranger_cmd = 'ranger --cmd="set draw_borders both"'
  highlight link RnvimrNormal CursorLine
  let g:rnvimr_action = {'<C-t>': 'NvimEdit tabedit','<C-x>': 'NvimEdit split','<C-v>': 'NvimEdit vsplit','gw': 'JumpNvimCwd','yw': 'EmitRangerCwd'}

  let g:rnvimr_layout = {'relative': 'editor','width': float2nr(round(0.7 * &columns)),'height': float2nr(round(0.7 * &lines)),'col': float2nr(round(0.15 * &columns)),'row': float2nr(round(0.15 * &lines)),'style': 'minimal'}

  let g:rnvimr_presets = [{'width': 0.600, 'height': 0.600},{},{'width': 0.800, 'height': 0.800},{'width': 0.950, 'height': 0.950},{'width': 0.500, 'height': 0.500, 'col': 0, 'row': 0},{'width': 0.500, 'height': 0.500, 'col': 0, 'row': 0.5},{'width': 0.500, 'height': 0.500, 'col': 0.5, 'row': 0},{'width': 0.500, 'height': 0.500, 'col': 0.5, 'row': 0.5},{'width': 0.500, 'height': 1.000, 'col': 0, 'row': 0},{'width': 0.500, 'height': 1.000, 'col': 0.5, 'row': 0},{'width': 1.000, 'height': 0.500, 'col': 0, 'row': 0},{'width': 1.000, 'height': 0.500, 'col': 0, 'row': 0.5}]
]],
	false
)
