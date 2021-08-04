local vim = vim
vim.g.vimspector_enable_mappings = "VISUAL_STUDIO"
vim.api.nvim_exec(
	[[
  noremap <space>vs :tabe .vimspector.json<CR>:LoadVimSpectorJsonTemplate<CR>
  sign define vimspectorBP text=☛ texthl=Normal
  sign define vimspectorBPDisabled text=☞ texthl=Normal
  sign define vimspectorPC text=🔶 texthl=SpellBad
]],
	false
)
vim.api.nvim_command([[
   function! s:read_template_into_buffer(template)
   	" has to be a function to avoid the extra space fzf#run insers otherwise
   	execute '0r ~/.config/nvim/sample_vimspector_json/'.a:template
   endfunction
  command! -bang -nargs=* LoadVimSpectorJsonTemplate call fzf#run({'source': 'ls -1 ~/.config/nvim/sample_vimspector_json','down': 20,'sink': function('<sid>read_template_into_buffer')})
]])
