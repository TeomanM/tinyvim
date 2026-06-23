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
			vim.cmd("normal! \27")
			local src_buf = vim.api.nvim_get_current_buf()
			local selection_ft = vim.bo.filetype
			local start_line = vim.fn.line("'<") - 1
			local end_line = vim.fn.line("'>")
			local selection = vim.api.nvim_buf_get_lines(src_buf, start_line, end_line, false)
			local builtin = require("fzf-lua.previewer.builtin")
			local Previewer = builtin.base:extend()
			function Previewer:new(o, opts, fzf_win)
				Previewer.super.new(self, o, opts, fzf_win)
				setmetatable(self, Previewer)
				return self
			end
			function Previewer:populate_preview_buf(entry_str)
				local tmpbuf = self:get_tmp_buffer()
				local lines = { "## " .. entry_str, "" }
				table.insert(lines, "```" .. selection_ft)
				vim.list_extend(lines, selection)
				table.insert(lines, "```")
				vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, lines)
				vim.bo[tmpbuf].filetype = "markdown"
				self:set_preview_buf(tmpbuf)
				self.win:update_preview_scrollbar()
			end
			function Previewer:gen_winopts()
				return vim.tbl_extend("force", self.winopts, { wrap = true, number = false })
			end
			require("fzf-lua").fzf_exec(presets, {
				prompt = "Ask Claude: ",
				previewer = Previewer,
				no_resume = true,
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
