local vim = vim
local cmd = vim.cmd

cmd("filetype on")
cmd("colorscheme OceanicNext")
vim.api.nvim_set_keymap("n", "re", ":call StylesBackgroundOpacityToggle()<CR>", { noremap = true })
vim.g.StylesBOpacity = 0
cmd([[
  function! StylesBackgroundOpacityToggle()
      if g:StylesBOpacity == 0
          execute "highlight Normal ctermfg=None ctermbg=None guifg=None guibg=None"
          execute "highlight! NonText ctermfg=gray guifg=grey10"
          set nocursorline
          set cc=0
          let g:StylesBOpacity = 1
      else
          colorscheme OceanicNext
          execute "highlight! NonText ctermfg=gray guifg=grey10"
          set cursorline
          " set cc=100
          let g:StylesBOpacity = 0
      endif
  endfunction
]])

vim.g.indent_guides_guide_size = 1
vim.g.indent_guides_start_level = 2
