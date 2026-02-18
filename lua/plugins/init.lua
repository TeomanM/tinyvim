---@type LazySpec
return {
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons", opts = {}, lazy = false },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        lazy = false,
        --TODO
        opts = {
            sections = {
                lualine_c = {"filename", "lsp_status"}
            },
            extensions = { "fzf", "lazy", "man", "mason", "neo-tree", "trouble" },
            theme = "auto",
        }
    },
    { "lewis6991/gitsigns.nvim", opts = {}, lazy = false },
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        ---@type neotree.Config
        opts = {
            hide_root_node = true,
            retain_hidden_root_indent = true,
            filesystem = {
                filtered_items = {
                    show_hidden_count = false,
                    never_show = {
                        '.DS_Store',
                    },
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true,
                    expander_collapsed = '',
                    expander_expanded = '',
                },
            },
        },
        keys = {
            { "<leader>e", "<cmd>Neotree<cr>",        desc = "Open Neotree" },
            { "<C-n>",     "<cmd>Neotree toggle<CR>", desc = "Neotree Toggle" }
        }
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
        version = "2.*",
        config = function()
            require("window-picker").setup({
                filter_rules = {
                    include_current_win = false,
                    autoselect_one = true,
                    -- filter using buffer options
                    bo = {
                        -- if the file type is one of following, the window will be ignored
                        filetype = { "neo-tree", "neo-tree-popup", "notify", "trouble", "NeogitStatus" },
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
        "akinsho/bufferline.nvim",
        opts = require("plugins.configs.bufferline"),
        lazy = false,
        dependencies = { "tiagovla/scope.nvim", config = true }
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
        opts = {
        },

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
            autoload = false,
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
    -- {
    --     "folke/noice.nvim",
    --     event = "VeryLazy",
    --     opts = {
    --         lsp = {
    --             -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    --             override = {
    --                 ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
    --                 ["vim.lsp.util.stylize_markdown"] = true,
    --                 ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    --             },
    --         },
    --         -- you can enable a preset for easier configuration
    --         presets = {
    --             bottom_search = true,         -- use a classic bottom cmdline for search
    --             command_palette = true,       -- position the cmdline and popupmenu together
    --             long_message_to_split = true, -- long messages will be sent to a split
    --             inc_rename = false,           -- enables an input dialog for inc-rename.nvim
    --             lsp_doc_border = false,       -- add a border to hover docs and signature help
    --         },
    --     },
    --
    --     dependencies = {
    --         -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    --         "MunifTanjim/nui.nvim",
    --         -- OPTIONAL:
    --         --   `nvim-notify` is only needed, if you want to use the notification view.
    --         --   If not available, we use `mini` as the fallback
    --         "rcarriga/nvim-notify",
    --     }
    -- },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000
    }
}
