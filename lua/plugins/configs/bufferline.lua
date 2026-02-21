---@type bufferline.UserConfig
return {
	options = {
		themable = true,
		offsets = {
			{ filetype = "NvimTree", highlight = "NvimTreeNormal" },
		},
		separator_style = "slant",
		diagnostics = "nvim_lsp",
		---@diagnostic disable-next-line: unused-local
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
	},
}
