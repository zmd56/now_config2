---  HELPERS  ---

local cmd = vim.cmd
local opt = vim.opt

---  VIM ONLY COMMANDS  ---

cmd("filetype plugin on")
cmd('let &titleold="' .. TERMINAL .. '"')
cmd("set inccommand=split")
cmd("set iskeyword+=-")

if O.line_wrap_cursor_movement then
	cmd("set whichwrap+=<,>,[,],h,l")
end

if O.transparent_window then
	cmd("au ColorScheme * hi Normal ctermbg=none guibg=none")
	cmd("au ColorScheme * hi SignColumn ctermbg=none guibg=none")
	cmd("let &fcs='eob: '")
end
cmd([[
  set list lcs=tab:\┊\ ,trail:▫
  au BufReadPost * if line("'\"") > 1|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
  source $HOME/.config/nvim/lua/core/md-snippets.lua
  autocmd BufRead,BufNewFile *.md setlocal spell
  source $HOME/.config/nvim/lua/core/tex-snippets.vim
  autocmd BufRead,BufNewFile *.tex setlocal spell
  set fillchars=fold:\ ,vert:\│,eob:\ ,msgsep:‾
  autocmd FileType json syntax match Comment +\/\/.\+$+
]])
vim.g.ruby_host_prog = { '$HOME/.local/share/gem/ruby/3.0.0/bin/neovim-ruby-host' }

---  SETTINGS  ---

opt.shortmess:append("c")

local disabled_built_ins = {
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"gzip",
	"zip",
	"zipPlugin",
	"tar",
	"tarPlugin", -- 'man',
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"logipat",
	"rrhelper",
	"spellfile_plugin",
	-- 'matchit', 'matchparen', 'shada_plugin',
}

if O.leader_key == " " or O.leader_key == "space" then
	vim.g.mapleader = " "
else
	vim.g.mapleader = O.leader_key
end

for _, plugin in pairs(disabled_built_ins) do
	vim.g["loaded_" .. plugin] = 1
end

for k, v in pairs(O.default_options) do
	vim.opt[k] = v
end
