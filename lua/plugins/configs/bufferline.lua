---@type bufferline.UserConfig
return {
	options = {
		always_show_bufferline = true,
		show_buffer_close_icons = false,
		show_close_icon = false,
		themable = true,
		offsets = {
			{
				filetype = "neo-tree",
				text = "NeoTree",
				text_align = "left",
				separator = false,
			},
		},
		get_element_icon = function(element)
			local icon, hl, _ = require("mini.icons").get("filetype", element.filetype)
			return icon, hl
		end,
		separator_style = "slant",
		diagnostics = "nvim_lsp",
		---@diagnostic disable-next-line: unused-local
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
	},
}
