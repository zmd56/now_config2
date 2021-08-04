local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
	execute("packadd packer.nvim")
end

local packer_ok, packer = pcall(require, "packer")
if not packer_ok then
	return
end

packer.init({
	-- package_root = require("packer.util").join_paths(vim.fn.stdpath "data", "lvim", "pack"),
	git = { clone_timeout = 300 },
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "single" })
		end,
	},
})

return require("packer").startup(function(use)
	-- Packer can manage itself as an optional plugin
	use("wbthomason/packer.nvim")

	-- TODO: refactor all of this (for now it works, but yes I know it could be wrapped in a simpler function)
	use({ "neovim/nvim-lspconfig" })
	use({
		"kabouzeid/nvim-lspinstall",
		event = "VimEnter",
		config = function()
			require("lspinstall").setup()
		end,
	})

	use({ "nvim-lua/popup.nvim" })
	use({ "nvim-lua/plenary.nvim" })
	use({ "tjdevries/astronauta.nvim" })

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		config = [[require('core.telescope').setup()]],
	})

	-- Autocomplete
	use({
		"hrsh7th/nvim-compe",
		-- event = "InsertEnter",
		config = function()
			require("core.compe").setup()
		end,
	})

	-- Autopairs
	use({
		"windwp/nvim-autopairs",
		-- event = "InsertEnter",
		after = { "telescope.nvim" },
		config = function()
			require("core.autopairs")
		end,
	})

	-- Snippets
	use({ "hrsh7th/vim-vsnip", event = "InsertCharPre" })
	use({ "rafamadriz/friendly-snippets", event = "InsertCharPre" })

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("core.treesitter").setup()
		end,
	})

	-- Formatter.nvim
	use({
		"mhartington/formatter.nvim",
		config = function()
			require("core.formatter")
		end,
	})

	-- NvimTree
	use({
		"kyazdani42/nvim-tree.lua",
		-- event = "BufWinOpen",
		-- cmd = "NvimTreeToggle",
		commit = "fd7f60e242205ea9efc9649101c81a07d5f458bb",
		config = function()
			require("core.nvimtree").setup()
		end,
	})

	-- git提示
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("core.gitsigns").setup()
		end,
		event = "BufRead",
	})

	-- whichkey
	use({
		"folke/which-key.nvim",
		config = function()
			require("core.which-key").setup()
		end,
		event = "BufWinEnter",
	})

	-- Comments
	use({
		"terrortylor/nvim-comment",
		event = "BufRead",
		config = function()
			local status_ok, nvim_comment = pcall(require, "nvim_comment")
			if not status_ok then
				return
			end
			nvim_comment.setup()
		end,
	})

	-- vim-rooter
	use({
		"airblade/vim-rooter",
		config = function()
			vim.g.rooter_silent_chdir = 1
		end,
	})

	-- Icons
	use({ "kyazdani42/nvim-web-devicons" })

	-- Status Line and Bufferline
	use({
		"glepnir/galaxyline.nvim",
		config = function()
			require("core.galaxyline")
		end,
		event = "BufWinEnter",
		disable = not O.plugin.galaxyline.active,
	})

	use({
		"romgrk/barbar.nvim",
		config = function()
			require("core.bufferline")
		end,
		event = "BufWinEnter",
	})

	-- Debugging
	use({
		"mfussenegger/nvim-dap",
		-- event = "BufWinEnter",
		config = function()
			require("core.dap").setup()
		end,
		disable = not O.plugin.dap.active,
	})

	-- Debugger management
	use({
		"Pocco81/DAPInstall.nvim",
		-- event = "BufWinEnter",
		-- event = "BufRead",
		disable = not O.plugin.dap.active,
	})

	-- Builtins, these do not load by default

	-- Dashboard
	use({
		"ChristianChiarulli/dashboard-nvim",
		event = "BufWinEnter",
		config = function()
			require("core.dashboard").setup()
		end,
		disable = not O.plugin.dashboard.active,
	})

	-- TODO: remove in favor of akinsho/nvim-toggleterm.lua
	-- Floating terminal
	use({
		"numToStr/FTerm.nvim",
		event = "BufWinEnter",
		config = function()
			require("core.floatterm").setup()
		end,
		disable = not O.plugin.floatterm.active,
	})

	-- Zen Mode
	use({
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		event = "BufRead",
		config = function()
			require("core.zen").setup()
		end,
		disable = not O.plugin.zen.active,
	})

	---------------------------------------------------------------------------------

	-- LANGUAGE SPECIFIC GOES HERE
	use({
		"lervag/vimtex",
		ft = "tex",
	})

	-- Rust tools
	-- TODO: use lazy loading maybe?
	use({
		"simrat39/rust-tools.nvim",
		disable = not O.lang.rust.rust_tools.active,
	})

	-- Elixir
	use({ "elixir-editors/vim-elixir", ft = { "elixir", "eelixir", "euphoria3" } })

	-- Javascript / Typescript
	use({
		"jose-elias-alvarez/nvim-lsp-ts-utils",
		ft = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
	})

	use({
		"mfussenegger/nvim-jdtls",
		-- ft = { "java" },
		disable = not O.lang.java.java_tools.active,
	})

	-- markdown
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && yarn install",
		requires = { { "dhruvasagar/vim-table-mode" }, { "mzlogin/vim-markdown-toc" }, { "dkarter/bullets.vim" } },
		config = function()
			require("core.markdown")
		end,
	})

	---------------------------------------------------------------------------------
	-- Install user plugins

	-- 多行修改
	use({ "mg979/vim-visual-multi", branch = "master" })

	-- 选择操作
	use({ "gcmt/wildfire.vim" })

	-- 快速对齐
	use({
		"junegunn/vim-easy-align",
		config = function()
			require("core.easyalign")
		end,
	})

	-- 翻译
	use({
		"voldikss/vim-translator",
		config = function()
			require("core.translator")
		end,
	})

	-- tagbar
	-- use({
	-- 	"preservim/tagbar",
	-- 	config = function()
	-- 		require("core.tagbar")
	-- 	end,
	-- })

	-- fzf
	use({
		"junegunn/fzf.vim",
		config = function()
			require("core.fzf")
		end,
	})

	-- 成对修改符号
	use({ "tpope/vim-surround" })

	-- rnvimr
	use({
		"kevinhwang91/rnvimr",
		config = function()
			require("core.rnvimr")
		end,
	})

	-- 侧边栏
	use({
		"skywind3000/quickmenu.vim",
		config = function()
			require("core.quickmenu")
		end,
	})

	-- themes
	use({
		"mhartington/oceanic-next",
		config = function()
			require("core.theme")
		end,
	})

	-- i3高亮
	use("PotatoesMaster/i3-vim-syntax")

	-- 相同单词
	use({
		"itchyny/vim-cursorword",
		requires = { "lfv89/vim-interestingwords" },
	})

	-- coc
	-- use({ "neoclide/coc.nvim", branch = "release" })

	-- 自动保存
	use({
		"Pocco81/AutoSave.nvim",
		config = function()
			require("core.autosave")
		end,
	})

	-- 查找替换
	use({
		"brooth/far.vim",
		config = function()
			require("core.far")
		end,
	})

	-- lspsaga
	use({
		"glepnir/lspsaga.nvim",
		config = function()
			require("core.lspsaga")
		end,
	})

	-- 平滑移动
	use({
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup()
		end,
	})

	-- symbols
	use({
		"simrat39/symbols-outline.nvim",
		config = function()
			require("core.symbols")
		end,
	})

	-- 快速移动
	-- use({ "ggandor/lightspeed.nvim" })

	-- 着色器
	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	})

	-- 调试器
	use({
		"puremourning/vimspector",
		-- run = "./install_gadget.py --enable-python --enable-go --enable-bash --enable-c --force-enable-chrome",
		-- requires = { "puremourning/vimspector-web" },
		config = function()
			require("core.vimspector")
		end,
	})

	-- telescope-coc
	use({
		"fannheyward/telescope-coc.nvim",
		require("telescope").load_extension("coc"),
	})

	for _, plugin in pairs(O.user_plugins) do
		packer.use(plugin)
	end
end)
