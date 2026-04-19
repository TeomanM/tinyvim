vim.diagnostic.config({
	virtual_text = true,
	virtual_lines = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅙 ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
	underline = true,
	severity_sort = true,
})
-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = opts.buffer, desc = "Go to Declaration" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = opts.buffer, desc = "Go to Definition" })
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { buffer = opts.buffer, desc = "Add Workspace Folder" })
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { buffer = opts.buffer, desc = "Remove Workspace Folder" })
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, { buffer = opts.buffer, desc = "List Workspace Folders" })
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, { buffer = opts.buffer, desc = "Go to Type Definition" })
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { buffer = opts.buffer, desc = "Rename Symbol" })
		-- TODO: grX mappings with descriptions
	end,
})

vim.lsp.codelens.enable(true)
vim.lsp.document_color.enable(true)
vim.lsp.linked_editing_range.enable(true)
vim.lsp.inlay_hint.enable(true)
vim.lsp.inline_completion.enable(true)

-- These are taken directly from blink.cmp I think
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
	"stylua",
	"lua_ls",
	"html",
	"cssls",
	"ts_ls",
	"glsl_analyzer",
	"clangd",
	"ruff",
	"basedpyright",
	"systemd_lsp",
	"hyprls",
	"lemminx",
	"bashls",
	"oxlint",
	"docker_language_server",
	"taplo",
	"qmlls",
	"jsonls",
	"yamlls",
	"jdtls",
	"neocmake",
	"nil_ls",
}

local lua_lsp_settings = {
	Lua = {
		codeLens = {
			enable = false,
		},
		hint = {
			enable = false,
		},
		runtime = { version = "LuaJIT" },
		workspace = {
			library = {
				vim.fn.expand("$VIMRUNTIME/lua"),
				"$XDG_DATA_HOME/nvim",
				"${3rd}/luv/library",
				"$XDG_CONFIG_HOME/mpv/types",
				"/usr/share/somewm/lua",
			},
		},
	},
}

vim.lsp.config("lua_ls", { settings = lua_lsp_settings })

return servers
