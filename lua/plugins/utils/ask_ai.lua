--- Generic factory for "Ask AI" plugin specs (claude, pi, etc.)
--- Usage: return require("utils.ask_ai").new({ name = "Claude", term_name = "claude" })

local Presets = {
	"Explain this code",
	"Review this code for bugs",
	"Refactor this code",
	"Write tests for this code",
}

local function build_previewer(selection, selection_ft, filepath)
	local builtin = require("fzf-lua.previewer.builtin")
	local Previewer = builtin.base:extend()
	function Previewer:new(o, opts, fzf_win)
		Previewer.super.new(self, o, opts, fzf_win)
		setmetatable(self, Previewer)
		return self
	end

	function Previewer:populate_preview_buf(entry_str)
		local tmpbuf = self:get_tmp_buffer()
		local info = FzfLua.get_info()
		local header = (entry_str ~= "" and entry_str) or (info and info.query) or ""
		local lines = header and header ~= "" and { "## " .. header, "" } or {}
		if filepath and filepath ~= "" then
			table.insert(lines, "- Path: @" .. filepath)
			table.insert(lines, "")
		end
		table.insert(lines, "```" .. selection_ft)
		vim.list_extend(lines, selection)
		table.insert(lines, "```")
		vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, lines)
		self:set_preview_buf(tmpbuf)
		vim.bo[tmpbuf].filetype = "markdown"
		self.win:update_preview_scrollbar()
	end

	function Previewer:zero()
		local shell = require("fzf-lua.shell")
		local act = shell.stringify_data(function()
			self = self.win._previewer or self
			vim.defer_fn(function()
				if self.win and self.win:validate_preview() then
					self:populate_preview_buf("")
				end
			end, self.delay or 0)
		end, self.opts, "")
		return string.format("execute-silent(%s)", act)
	end

	function Previewer:gen_winopts()
		return vim.tbl_extend("force", self.winopts, { wrap = true, number = false })
	end

	return Previewer
end

local function build_send(term_name)
	if term_name ~= "claude" and term_name ~= "pi" then
		error("Unknown term: " .. term_name)
	end
	local get_term = (term_name == "claude") and require("plugins.utils.term_utils").get_or_create_claude_term
		or require("plugins.utils.term_utils").get_or_create_pi_term
	local send = function(question, filepath)
		if not question or question == "" then
			return
		end
		local term = get_term()
		term:send("visual_selection", {
			decorator = function(text)
				local result = { question .. "\n\n" }
				if filepath and filepath ~= "" then
					table.insert(result, "- Path: @" .. filepath .. "\n\n")
				end
				vim.list_extend(result, text)
				return result
			end,
			trim = false,
			new_line = false,
		})
		term:send({ "\r" }, { new_line = false, trim = false })
	end
	return send
end

local function normalize_filepath(filepath, start_line, end_line)
	if filepath and filepath ~= "" then
		local lines = start_line + 1 == end_line and ("L" .. end_line) or ("L" .. (start_line + 1) .. "-" .. end_line)
		filepath = filepath .. ":" .. lines
	end
	return filepath
end

--- Create an "Ask AI" plugin spec.
--- @param opts table { name: string, term_name: string }
--- @return LazyPluginSpec
local function new(opts)
	local display_name = opts.name or opts.term_name
	local term_name = opts.term_name
	local send = build_send(term_name)

	return {
		"<leader>a" .. term_name:sub(1, 1),
		function()
			vim.cmd("normal! \27")
			local src_buf = vim.api.nvim_get_current_buf()
			local filepath = vim.api.nvim_buf_get_name(src_buf)
			local selection_ft = vim.bo.filetype
			if selection_ft == "neo-tree" then
				filepath = ""
			end
			local start_line = vim.fn.line("'<") - 1
			local end_line = vim.fn.line("'>")
			local selection = vim.api.nvim_buf_get_lines(src_buf, start_line, end_line, false)
			filepath = normalize_filepath(filepath, start_line, end_line)

			require("fzf-lua").fzf_exec(Presets, {
				prompt = "Ask " .. display_name .. ": ",
				previewer = build_previewer(selection, selection_ft, filepath),
				no_resume = true,
				actions = {
					["default"] = function(selected, event_opts)
						send(selected[1] or event_opts.last_query, filepath)
					end,
				},
			})
		end,
		desc = "Send visual selection to " .. display_name,
		mode = { "v" },
	}
end

return { new = new }
