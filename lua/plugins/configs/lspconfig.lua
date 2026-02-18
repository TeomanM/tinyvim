-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

vim.lsp.config("*", { capabilities = capabilities })

local servers = {
    "lua_ls",
    "html",
    "cssls",
    "ts_ls",
    "glsl_analyzer",
    "clangd",
    "ruff",
    "systemd_lsp",
    "hyprls",
    "lemminx",
    "bashls",
    "oxlint",
    -- "oxfmt",
    "docker_language_server",
    "taplo",
    "qmlls",
    -- "beautysh",
    "jsonls",
    -- "teal_ls",
    "yamlls",
}

local lua_lsp_settings = {
    Lua = {
        runtime = { version = "LuaJIT" },
        workspace = {
            library = {
                vim.fn.expand("$VIMRUNTIME/lua"),
                "$XDG_DATA_HOME/nvim/lazy",
                "${3rd}/luv/library",
            },
        },
    },
}

vim.lsp.config("lua_ls", { settings = lua_lsp_settings })
vim.lsp.config.qmlls = {
    cmd = { "qmlls", "-E" },
}
vim.lsp.config.teal_ls = {
    cmd = { "/home/teoman/.luarocks/bin/teal-language-server" },
}
vim.lsp.enable({ "lua_ls", "qmlls", "teal_ls" })
return servers
