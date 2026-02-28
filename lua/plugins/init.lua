---@type LazyPluginSpec[]
return {
	{ "nvim-lua/plenary.nvim" },
	{ "nvim-tree/nvim-web-devicons", opts = {}, lazy = false },
	{ "nvim-mini/mini.icons", version = false },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		opts = require("plugins.configs.lualine"),
	},
	{
		"waiting-for-dev/ergoterm.nvim",
		---@type ErgoTermConfig
		opts = {
			terminal_defaults = {
				auto_scroll = true,
				persist_mode = true,
				size = {
					above = "25%",
					below = "25%",
					left = "25%",
					right = "25%",
				},
			},
		},
		keys = require("plugins.configs.ergoterm"),
	},
	{ "lewis6991/gitsigns.nvim", opts = {}, lazy = false },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "main",
		opts = require("plugins.configs.neotree"),
		keys = {
			{ "<leader>e", "<cmd>Neotree<cr>", desc = "Open Neotree" },
			{ "<C-n>", "<cmd>Neotree toggle<CR>", desc = "Neotree Toggle" },
		},
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
	{
		"s1n7ax/nvim-window-picker",
		version = "*",
		config = function()
			---@diagnostic disable-next-line: undefined-field
			require("window-picker").setup({
				filter_rules = {
					include_current_win = false,
					autoselect_one = true,
					-- filter using buffer options
					bo = {
						-- if the file type is one of following, the window will be ignored
						filetype = { "neo-tree", "neo-tree-popup", "notify", "trouble", "NeogitStatus", "ergoterm" },
						-- if the buffer type is one of following, the window will be ignored
						buftype = { "terminal", "quickfix" },
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate | TSInstallAll",
		opts = function()
			return require("plugins.configs.treesitter")
		end,
		lazy = false,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {},
		lazy = false,
	},
	{
		"akinsho/bufferline.nvim",
		opts = require("plugins.configs.bufferline"),
		lazy = false,
	},
	{ "tiagovla/scope.nvim", lazy = false, config = true },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		---@type wk.Opts
		opts = {
			preset = "modern",
		},
		keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
	},

	{
		"saghen/blink.cmp",
		version = "*",
		event = "InsertEnter",
		dependencies = {
			"rafamadriz/friendly-snippets",
			-- snippets engine
			{
				"L3MON4D3/LuaSnip",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},

			{ "windwp/nvim-autopairs", opts = {} },
			{ "onsails/lspkind.nvim" },
			{ "xzbdmw/colorful-menu.nvim" },
			{ "nvim-mini/mini.icons", version = false },
		},
		-- made opts a function cuz cmp config calls cmp module
		-- and we lazyloaded cmp so we dont want that file to be read on startup!
		opts = function()
			return require("plugins.configs.blink")
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		---@type MasonLspconfigSettings
		opts = {
			ensure_installed = require("plugins.configs.lspconfig"),
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		lazy = false,
	},
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
	{
		"stevearc/conform.nvim",
		opts = require("plugins.configs.conform"),
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {
			whitespace = { highlight = { "Whitespace", "NonText" } },
		},
		event = { "BufReadPre", "BufNewFile" },
	},
	-- files finder etc
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		opts = require("plugins.configs.telescope"),
		dependencies = {
			"BurntSushi/ripgrep",
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = {
			"nvim-mini/mini.icons",
			"nvim-treesitter/nvim-treesitter-context",
			"mfussenegger/nvim-dap",
			"MeanderingProgrammer/render-markdown.nvim",
		},
		---@module "fzf-lua"
		---@type fzf-lua.Config|{}
		---@diagnostic disable: missing-fields
		opts = {},
		keys = require("plugins.configs.fzf-lua"),
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"ibhagwan/fzf-lua",
		},
		cmd = "Neogit",
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "󰊢 Show Neogit UI " },
		},
	},
	{
		"mrcjkb/rustaceanvim",
		version = "*",
		lazy = false, -- This plugin is already lazy
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown", "quarto" },
		---@type render.md.Config
		opts = {
			completions = {
				blink = {
					enabled = true,
				},
			},
		},
	},
	{
		"MagicDuck/grug-far.nvim",
		keys = {
			{ "<leader>gf", "<cmd>GrugFar<cr>", desc = "Search & Replace" },
		},
	},
	{
		"folke/trouble.nvim",
		---@type trouble.Config
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = function()
			return require("plugins.configs.trouble")
		end,
	},
	{
		"Kenzo-Wada/boundary.nvim",
		branch = "release",
		opts = {
			auto = true, -- automatic refresh enabled by default
			-- marker_text = "'use client'",
		},
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	},
	{
		"brianhuster/live-preview.nvim",
		dependencies = {
			"ibhagwan/fzf-lua",
		},
		keys = {
			{ "<leader>pr", "<cmd>LivePreview start<cr>", desc = "Start LivePreview server" },
		},
		ft = { "markdown", "html", "asciidoc", "svg" },
	},
	{
		"michaelb/sniprun",
		branch = "master",
		build = "sh install.sh",
		keys = {
			{
				"<leader>rs",
				"<cmd>SnipRun<cr>",
				desc = "Run selected snippet of code",
			},
		},
	},
	{
		"josephschmitt/pj.nvim",
		dependencies = {
			"ibhagwan/fzf-lua",
		},
		cmd = { "Pj", "PjCd" },
		keys = {
			{ "<leader>fp", "<cmd>Pj<cr>", desc = "Find projects (global)" },
		},
		opts = {
			picker = { type = "fzf_lua" },
		},
	},
	{
		"nemanjamalesija/smart-paste.nvim",
		event = "VeryLazy",
		config = true,
	},
	{
		"gbprod/yanky.nvim",
		dependencies = {
			{ "kkharji/sqlite.lua" },
		},
		opts = {
			ring = { storage = "sqlite" },
		},
		-- init is called during startup. Configuration for vim plugins typically should be set in an init function
		init = function()
			require("telescope").load_extension("yank_history")
		end,
		keys = function()
			return require("plugins.configs.yanky")
		end,
	},
	{
		"debugloop/telescope-undo.nvim",
		dependencies = { -- note how they're inverted to above example
			{
				"nvim-telescope/telescope.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		keys = {
			{ -- lazy style key map
				"<leader>u",
				"<cmd>Telescope undo<cr>",
				desc = "undo history",
			},
		},
		config = function()
			require("telescope").load_extension("undo")
		end,
	},
	{
		"saxon1964/neovim-tips",
		version = "*", -- Only update on tagged releases
		dependencies = {
			"MunifTanjim/nui.nvim",
			"MeanderingProgrammer/render-markdown.nvim", -- Clean rendering
		},
		opts = {
			daily_tip = 0,
			bookmark_symbol = "🌟 ",
		},
		keys = {
			{ "<leader>to", ":NeovimTips<CR>", desc = "Tips Open Tips" },
			{ "<leader>tm", ":NeovimTipsBookmarks<CR>", desc = "Tips Show Bookmarked Tips" },
		},
	},
	{
		"m4xshen/hardtime.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		lazy = false,
		opts = {
			enabled = false,
		},
	},
	{
		"stephansama/fzf-nerdfont.nvim",
		lazy = true,
		build = ":FzfNerdfont generate",
		dependencies = { "ibhagwan/fzf-lua" },
		cmd = "FzfNerdfont",
		keys = {
			{ "<leader>fi", "<CMD>FzfNerdfont<CR>", desc = "Nerd Font Symbols" },
		},
		opts = {},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		keys = function()
			return require("plugins.configs.flash")
		end,
	},

	{
		"aronjohanns/smooth-resize.nvim",
		event = "WinResized",
	},
	-- Lua
	{
		"stevearc/resession.nvim",
		opts = {},
		keys = {
			{
				"<leader>sf",
				function()
					local resession = require("resession")
					require("fzf-lua")
					FzfLua.fzf_exec(resession.list(), {
						actions = {
							["default"] = function(selected)
								resession.load(selected[1])
							end,
						},
					})
				end,
				desc = "Resession",
			},
		},
	},
	{
		"nyoom-engineering/oxocarbon.nvim",
	},
	{
		"tiagovla/tokyodark.nvim",
	},
	{
		"maxmx03/fluoromachine.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			---@type fluoromachine
			local fm = require("fluoromachine")

			fm.setup({
				theme = "fluoromachine",
			})
		end,
	},
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
}
