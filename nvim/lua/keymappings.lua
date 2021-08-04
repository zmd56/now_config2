local function register_mappings(mappings, default_options)
	for mode, mode_mappings in pairs(mappings) do
		for _, mapping in pairs(mode_mappings) do
			local options = #mapping == 3 and table.remove(mapping) or default_options
			local prefix, cmd = unpack(mapping)
			pcall(vim.api.nvim_set_keymap, mode, prefix, cmd, options)
		end
	end
end

local mappings = {
	i = { -- Insert mode

		-- Move current line / block with Alt-j/k ala vscode.
		{ "<A-j>", "<Esc>:m .+1<CR>==gi" },
		{ "<A-k>", "<Esc>:m .-2<CR>==gi" },

		-- Terminal window navigation
		{ "<C-h>", "<C-\\><C-N><C-w>h" },
		{ "<C-j>", "<C-\\><C-N><C-w>j" },
		{ "<C-k>", "<C-\\><C-N><C-w>k" },
		{ "<C-l>", "<C-\\><C-N><C-w>l" },
	},
	n = { -- Normal mode
		-- Better window movement
		{ "<C-h>", "<C-w>h", { silent = true } },
		{ "<C-j>", "<C-w>j", { silent = true } },
		{ "<C-k>", "<C-w>k", { silent = true } },
		{ "<C-l>", "<C-w>l", { silent = true } },

		-- Resize with arrows
		{ "<C-Up>", ":resize -2<CR>", { silent = true } },
		{ "<C-Down>", ":resize +2<CR>", { silent = true } },
		{ "<C-Left>", ":vertical resize -2<CR>", { silent = true } },
		{ "<C-Right>", ":vertical resize +2<CR>", { silent = true } },

		-- Tab switch buffer
		-- { "<TAB>", ":bnext<CR>" },
		-- { "<S-TAB>", ":bprevious<CR>" },

		-- Move current line / block with Alt-j/k a la vscode.
		{ "<A-j>", ":m .+1<CR>==" },
		{ "<A-k>", ":m .-2<CR>==" },

		-- QuickFix
		{ "]q", ":cnext<CR>" },
		{ "[q", ":cprev<CR>" },

		-- {'<C-TAB>', 'compe#complete()', {noremap = true, silent = true, expr = true}},
	},
	t = { -- Terminal mode
		-- Terminal window navigation
		{ "<C-h>", "<C-\\><C-N><C-w>h" },
		{ "<C-j>", "<C-\\><C-N><C-w>j" },
		{ "<C-k>", "<C-\\><C-N><C-w>k" },
		{ "<C-l>", "<C-\\><C-N><C-w>l" },
	},
	v = { -- Visual/Select mode
		-- Better indenting
		{ "<", "<gv" },
		{ ">", ">gv" },

		-- { "p", '"0p', { silent = true } },
		-- { "P", '"0P', { silent = true } },
	},
	x = { -- Visual mode
		-- Move selected line / block of text in visual mode
		{ "K", ":move '<-2<CR>gv-gv" },
		{ "J", ":move '>+1<CR>gv-gv" },

		-- Move current line / block with Alt-j/k ala vscode.
		{ "<A-j>", ":m '>+1<CR>gv-gv" },
		{ "<A-k>", ":m '<-2<CR>gv-gv" },
	},
	[""] = {
		-- Toggle the QuickFix window
		{ "<C-q>", ":call QuickFixToggle()<CR>" },
	},
}

-- TODO: fix this
if vim.fn.has("mac") == 1 then
	mappings["n"][5][1] = "<A-Up>"
	mappings["n"][6][1] = "<A-Down>"
	mappings["n"][7][1] = "<A-Left>"
	mappings["n"][8][1] = "<A-Right>"
end

register_mappings(mappings, { silent = true, noremap = true })

vim.cmd('inoremap <expr> <c-j> ("\\<C-n>")')
vim.cmd('inoremap <expr> <c-k> ("\\<C-p>")')

-- vim.cmd('inoremap <expr> <TAB> (\"\\<C-n>\")')
-- vim.cmd('inoremap <expr> <S-TAB> (\"\\<C-p>\")')

-- vim.cmd([[
-- map p <Plug>(miniyank-autoput)
-- map P <Plug>(miniyank-autoPut)
-- map <leader>n <Plug>(miniyank-cycle)
-- map <leader>N <Plug>(miniyank-cycleback)
-- ]])

-- ;改:
vim.api.nvim_set_keymap("n", ";", ":", { noremap = true })
vim.api.nvim_set_keymap("v", ";", ":", { noremap = true })

-- nvimTree
vim.api.nvim_set_keymap("", "<F3>", "<cmd>lua require'core.nvimtree'.toggle_tree()<CR>", { noremap = true })

-- insert
vim.api.nvim_set_keymap("i", "<A-i>", "<Home>", { noremap = true })
vim.api.nvim_set_keymap("i", "<A-a>", "<End>", { noremap = true })
vim.api.nvim_set_keymap("i", "<A-h>", "<Left>", { noremap = true })
vim.api.nvim_set_keymap("i", "<A-j>", "<Down>", { noremap = true })
vim.api.nvim_set_keymap("i", "<A-k>", "<Up>", { noremap = true })
vim.api.nvim_set_keymap("i", "<A-l>", "<Right>", { noremap = true })
vim.api.nvim_set_keymap("i", "<A-H>", "<BS>", { noremap = true })
vim.api.nvim_set_keymap("i", "<A-J>", "<PageDown>", { noremap = true })
vim.api.nvim_set_keymap("i", "<A-K>", "<PageUp>", { noremap = true })
vim.api.nvim_set_keymap("i", "<A-L>", "<Del>", { noremap = true })
vim.api.nvim_set_keymap("i", "<A-w>", "<C-w>", { noremap = true })
vim.api.nvim_set_keymap("i", "<A-u>", "<C-u>", { noremap = true })
vim.api.nvim_set_keymap("i", "<A-o>", "<C-m>", { noremap = true })
vim.api.nvim_set_keymap("i", "<A-O>", "<ESC>O", { noremap = true })

-- 快速跳转行首/行尾
vim.api.nvim_set_keymap("n", ",", 'col(".")==1?"$":"0"', { noremap = true, expr = true })
vim.api.nvim_set_keymap("v", ",", 'col(".")==1?"$h":"0"', { noremap = true, expr = true })

-- 清除搜索高亮
vim.api.nvim_set_keymap("n", "cl", ":nohlsearch<CR>", { noremap = true })

-- 键映射
vim.api.nvim_set_keymap("n", "W", "5w", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "B", "5b", { noremap = true, silent = true })

-- 创建窗口
vim.api.nvim_set_keymap("n", "<space><space>l", ":set splitright<CR>:vsplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space><space>h", ":set nosplitright<CR>:vsplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space><space>k", ":set nosplitbelow<CR>:split<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space><space>j", ":set splitbelow<CR>:split<CR>", { noremap = true, silent = true })

-- 一键编译
vim.api.nvim_exec(
	[[
  noremap r :call CompileRunGcc()<CR>
  func! CompileRunGcc()
    exec "w"
  	if &filetype == 'c'
  		exec "!gcc % -o %<"
  		exec "!time ./%<"
  	elseif &filetype == 'cpp'
      exec '!g++ -std=c++11 % -Wall -o %<'
      exec '!time ./%<'
  	elseif &filetype == 'java'
  		exec "!javac %"
  		exec "!time java %<"
  	elseif &filetype == 'sh'
  		:!time bash %
  	elseif &filetype == 'python'
  		set splitbelow
  		:sp
  		:term python3 %
  	elseif &filetype == 'html'
      exec "!firefox % &"
  	elseif &filetype == 'markdown'
  		exec "MarkdownPreview"
  	elseif &filetype == 'tex'
  		silent! exec "VimtexStop"
  		silent! exec "VimtexCompile"
  	elseif &filetype == 'dart'
  		exec "CocCommand flutter.run -d ".g:flutter_default_device." ".g:flutter_run_args
  		silent! exec "CocCommand flutter.dev.openDevLog"
  	elseif &filetype == 'javascript'
  		set splitbelow
  		:sp
  		:term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
  	elseif &filetype == 'go'
  		set splitbelow
  		:sp
  		:term go run %
  	endif
  endfunc
]],
	false
)
