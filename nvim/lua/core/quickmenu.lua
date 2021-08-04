local vim = vim

vim.api.nvim_exec(
	[[
  call quickmenu#reset()
  let g:quickmenu_options = "HL"
  noremap <silent> <F12> :call quickmenu#toggle(0)<CR>
  call quickmenu#append("# Notes", '')
  call quickmenu#append("Open %{expand('vim笔记')}", 'e ~/Program/md/vim/vim笔记/VIM学习.md')
  call quickmenu#append("Open %{expand('arch笔记')}", 'e ~/Program/md/vim/archlinux学习笔记/ArchLinux学习笔记.md')
  call quickmenu#append("Open %{expand('golang笔记')}", 'e ~/Program/md/vim/go笔记/go笔记.md')
  call quickmenu#append("Open %{expand('ranger笔记')}", 'e ~/Program/md/vim/ranger笔记/ranger.md')
]],
	false
)
