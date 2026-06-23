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
			local ergo = require("ergoterm")
			local claude = term_utils.get_claude_term()
			if claude == nil then
				claude = ergo:new({
					cmd = "claude",
					name = "claude",
					layout = "right",
					auto_list = false,
					bang_target = false,
					sticky = true,
					watch_files = true,
					size = { above = "35%", below = "35%", left = "35%", right = "35%" },
				})
			end
			claude:toggle()
		end,
		desc = "Toggle Claude Code",
		mode = { "n", "t" },
	},
	{
		"<leader>as",
		function()
			vim.ui.input({ prompt = "Ask Claude: " }, function(question)
				if not question or question == "" then return end
				local claude = term_utils.get_claude_term()
				claude:send("visual_selection", {
					decorator = function(text)
						local result = { question .. "\n\n" }
						vim.list_extend(result, text)
						return result
					end,
					trim = false,
				})
			end)
		end,
		desc = "Send visual selection to Claude",
		mode = { "v" },
	},
}
