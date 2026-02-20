---TODO: Send CD command or restart terminal
---when the directory is changed
return {
	{
		"<M-h>",
		function()
			local ergo = require("ergoterm")
			local horizontal = ergo.get_by_name("Horizontal")
			if horizontal == nil then
				horizontal = ergo:new({ layout = "below", name = "Horizontal" })
			end
			horizontal:toggle()
		end,
		desc = "Toggle Horizontal Terminal",
		mode = { "n", "t" },
	},
	{
		"<M-v>",
		function()
			local ergo = require("ergoterm")
			local vertical = ergo.get_by_name("Vertical")
			if vertical == nil then
				vertical = ergo:new({ layout = "right", name = "Vertical" })
			end
			vertical:toggle()
		end,
		desc = "Toggle Vertical Terminal",
		mode = { "n", "t" },
	},
	{
		"<M-i>",
		function()
			local ergo = require("ergoterm")
			local float = ergo.get_by_name("Floating")
			if float == nil then
				float = ergo:new({ layout = "float", name = "Floating", float_opts = { title = "Float Term" } })
			end
			float:toggle()
		end,
		desc = "Toggle Floating Terminal",
		mode = { "n", "t" },
	},
}
