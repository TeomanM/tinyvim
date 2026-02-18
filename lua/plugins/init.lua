---@type LazySpec
return {
    { "nvim-lua/plenary.nvim" },

    { "nvim-tree/nvim-web-devicons", opts = {}, lazy = false },
    { "echasnovski/mini.statusline", opts = {}, lazy = false },
    { "lewis6991/gitsigns.nvim",     opts = {}, lazy = false },

    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        opts = function()
            return require("plugins.configs.nvimtree")
        end,
        lazy = false,
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
        "akinsho/bufferline.nvim",
        opts = require("plugins.configs.bufferline"),
        lazy = false,
    },

    {
        "folke/which-key.nvim",
        keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
        cmd = "WhichKey",
    },

    -- we use blink plugin only when in insert mode
    -- so lets lazyload it at InsertEnter event
    {
        "saghen/blink.cmp",
        version = "1.*",
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

            -- autopairs , autocompletes ()[] etc
            { "windwp/nvim-autopairs", opts = {} },
        },
        -- made opts a function cuz cmp config calls cmp module
        -- and we lazyloaded cmp so we dont want that file to be read on startup!
        opts = function()
            return require("plugins.configs.blink")
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = require("plugins.configs.lspconfig"),
            automatic_enable = {
                exclude = {
                    "lua_ls",
                    "qmlls",
                    "teal_ls",
                },
            },
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
        lazy = false,
    },

    {
        "stevearc/conform.nvim",
        opts = require("plugins.configs.conform"),
    },

    {
        "nvimdev/indentmini.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },

    -- files finder etc
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        opts = require("plugins.configs.telescope"),
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        cmd = "Neogit",
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "󰊢 Show Neogit UI " },
        },
        -- opts = {
        -- 	kind = "auto",
        -- },
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^7",
        lazy = false, -- This plugin is already lazy
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
        ft = { "markdown", "quarto" },
        opts = {},
    },
    {
        "MagicDuck/grug-far.nvim",
        keys = {
            { "<leader>gf", "<cmd>GrugFar<cr>", desc = "Search & Replace" },
        },
    },
    {
        "folke/trouble.nvim",
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
            "nvim-telescope/telescope.nvim",
        },
        keys = {
            { "<leader>pr", "<cmd>LivePreview start<cr>", desc = "Start LivePreview server" },
        },
        ft = { "markdown", "html", "asciidoc", "svg" },
        opts = {
            dynamic_root = true,
        },
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
            "nvim-telescope/telescope.nvim",
        },
        cmd = { "Pj", "PjCd" },
        keys = {
            { "<leader>fp", "<cmd>Pj<cr>", desc = "Telescope find projects (global)" },
        },
        opts = {
            picker = { type = "telescope" },
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
            { "<leader>to", ":NeovimTips<CR>",          desc = "Tips Open Tips" },
            { "<leader>tb", ":NeovimTipsBookmarks<CR>", desc = "Tips Show Bookmarked Tips" },
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
            { "<leader>fi", "<CMD>FzfNerdfont<CR>", desc = "Telescope fzf nerd font picker" },
        },
        opts = {},
    },
    {
        "zion-off/mole.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
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
        opts = {},
        lazy = false,
    },
    -- Lua
    {
        "olimorris/persisted.nvim",
        event = "BufReadPre", -- Ensure the plugin loads only when a buffer has been loaded
        opts = {
            autoload = true,
            on_autoload_no_session = function()
                vim.notify("No existing session to load.")
            end,
        },
        init = function()
            require("telescope").load_extension("persisted")
        end,
        keys = {
            { "<leader>sf", "<cmd>Telescope persisted<cr>", { desc = "Telescope open saved sessions" } },
        },
    },
    {
        "nyoom-engineering/oxocarbon.nvim",
    },
}
