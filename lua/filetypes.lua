vim.filetype.add({
	pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

vim.filetype.add({
	pattern = { ["Caddyfile"] = "caddy" },
})

vim.filetype.add({
	extension = {
		mdx = "markdown",
	},
})
