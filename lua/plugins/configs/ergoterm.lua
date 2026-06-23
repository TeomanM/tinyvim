---@module "ergoterm"

local term_utils = require("utils.term_utils")

return {
	{
		"<M-h>",
		function()
			term_utils.toggle_tab_term("Horizontal", { layout = "below" })
		end,
		desc = "Toggle Horizontal Terminal",
		mode = { "n", "t" },
	},
	{
		"<M-v>",
		function()
			term_utils.toggle_tab_term("Vertical", { layout = "right" })
		end,
		desc = "Toggle Vertical Terminal",
		mode = { "n", "t" },
	},
	{
		"<M-i>",
		function()
			term_utils.toggle_tab_term("Floating", { layout = "float", float_opts = { title = "Floating Term" } })
		end,
		desc = "Toggle Floating Terminal",
		mode = { "n", "t" },
	},
	{
		"<M-a>",
		function()
			term_utils.get_or_create_claude_term():toggle()
		end,
		desc = "Toggle Claude Code",
		mode = { "n", "t" },
	},
	require("plugins.configs.ask_claude"),
}
