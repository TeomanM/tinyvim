return {
	options = {
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_c = { "filename", "lsp_status", "hostname" },
	},
	extensions = {
		"fzf",
		"lazy",
		"man",
		"mason",
		"neo-tree",
		"trouble",
		"quickfix",
		ergoterm = {
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{
						function()
							local ergo = require("ergoterm")
							local focused_term = ergo.get_focused()
							if focused_term ~= nil then
								return focused_term.layout
							end
						end,
					},
				},
				lualine_c = { "filetype" },
				lualine_x = {
					{
						function()
							local ergo = require("ergoterm")
							local focused_term = ergo:get_focused()
							if focused_term ~= nil then
								return vim.fn.getcwd()
							end
						end,
					},
					{
						function()
							local ergo = require("ergoterm")
							local focused_term = ergo:get_focused()
							if focused_term ~= nil then
								return focused_term:get_status_icon()
							end
						end,
					},
				},
			},
			filetypes = { "ergoterm" },
		},
	},
	theme = "auto",
}
