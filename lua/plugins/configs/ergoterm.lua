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
	{
		"<leader>as",
		function()
			local presets = {
				"Explain this code",
				"Review this code for bugs",
				"Refactor this code",
				"Write tests for this code",
			}
			local function send(question)
				if not question or question == "" then
					return
				end
				local claude = term_utils.get_or_create_claude_term()
				claude:send("visual_selection", {
					decorator = function(text)
						local result = { question .. "\n\n" }
						vim.list_extend(result, text)
						return result
					end,
					trim = false,
				})
				claude:send({ "\r" }, { new_line = false, trim = false })
			end
			require("fzf-lua").fzf_exec(presets, {
				prompt = "Ask Claude: ",
				actions = {
					["default"] = function(selected, opts)
						---@diagnostic disable-next-line: undefined-field
						send(selected[1] or opts.last_query)
					end,
				},
			})
		end,
		desc = "Send visual selection to Claude",
		mode = { "v" },
	},
}
