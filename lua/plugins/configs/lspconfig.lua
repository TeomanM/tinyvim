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
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { buffer = opts.buffer, desc = "Add Workspace Folder" })
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { buffer = opts.buffer, desc = "Remove Workspace Folder" })
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, { buffer = opts.buffer, desc = "List Workspace Folders" })
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, { buffer = opts.buffer, desc = "Go to Type Definition" })
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { buffer = opts.buffer, desc = "Rename Symbol" })
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
	"vtsls",
	"denols",
	"glsl_analyzer",
	"wgsl_analyzer",
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
	"postgres_lsp",
	"zls",
}

local lua_lsp_settings = {
	Lua = {
		codeLens = {
			enable = false,
		},
		hint = {
			enable = false,
		},
	},
}

vim.lsp.config("lua_ls", { settings = lua_lsp_settings })

-- Not in nvim-lspconfig or mason: configured and enabled by hand, runs straight from npm
vim.lsp.config("knip", {
	cmd = { "bunx", "--yes", "@knip/language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"json",
		"jsonc",
	},
	root_markers = { "knip.json", "knip.jsonc", "knip.ts", "knip.config.ts", "package.json" },
	-- knip only re-analyzes on workspace/didChangeWatchedFiles and registers no watchers of
	-- its own, so feed it the file events by hand on every write.
	on_attach = function(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = vim.api.nvim_create_augroup("KnipWatchedFiles" .. bufnr, { clear = true }),
			buffer = bufnr,
			callback = function(ev)
				local path = vim.api.nvim_buf_get_name(ev.buf)
				if path == "" then
					return
				end
				client:notify("workspace/didChangeWatchedFiles", {
					changes = { { uri = vim.uri_from_fname(path), type = 2 } },
				})
			end,
		})
	end,
})
vim.lsp.enable("knip")

vim.lsp.config("vtsls", {
	settings = {
		typescript = {
			tsserver = {
				experimental = {
					enableProjectDiagnostics = true,
				},
			},
		},
	},
})

-- Initialize codesettings.nvim for rustaceanvim
vim.lsp.config("rust-analyzer", {
	before_init = function(init_params, config)
		local codesettings = require("codesettings")
		codesettings.with_local_settings(config.name, config)
		-- Some settings must be passed at init time, for example rust-analyzer.workspace.discoverConfig
		if config.default_settings and config.default_settings[config.name] then
			init_params.initializationOptions = config.default_settings[config.name]
		end
	end,
})

return servers
