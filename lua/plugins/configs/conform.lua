---@type conform.setupOpts
return {
	formatters = {
		caddy = {
			command = "caddy",
			args = { "fmt", "-" },
			stdin = true,
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "oxfmt" },
		scss = { "oxfmt" },
		html = { "oxfmt" },
		typescript = { "oxfmt" },
		javascript = { "oxfmt" },
		typescriptreact = { "oxfmt" },
		javascriptreact = { "oxfmt" },
		json = { "oxfmt" },
		jsonc = { "oxfmt" },
		json5 = { "oxfmt" },
		yaml = { "oxfmt" },
		vue = { "oxfmt" },
		less = { "oxfmt" },
		markdown = { "oxfmt" },
		graphql = { "oxfmt" },
		toml = { "taplo" },
		caddy = { "caddy" },
		kdl = { "kdlfmt" },
		bash = { "beautysh" },
		sh = { "beautysh" },
	},

	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 0,
		lsp_fallback = true,
	},
}
