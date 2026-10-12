vim.filetype.add({
	pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

vim.filetype.add({
	pattern = { [".*Caddyfile"] = "caddy" },
})

vim.filetype.add({
	extension = {
		mdx = "markdown",
	},
})

-- WESL (WGSL + imports): its own filetype so wgsl_analyzer can tell them apart, but highlighted with
-- the wgsl treesitter parser (WESL is a superset; imports parse fine).
vim.filetype.add({
	extension = {
		wesl = "wesl",
	},
})
vim.treesitter.language.register("wgsl", "wesl")
