local M = {}

local function decode_name(name)
	local raw_path, branch = name:match("^(.-)__branch__(.+)$")
	return (raw_path or name):gsub("|", "/"), branch and branch:gsub("|", "/") or nil
end

function M.make_source(resession)
	local fzf_utils = require("fzf-lua.utils")
	local _, _, path_color = fzf_utils.ansi_from_hl("Directory", "")
	local _, _, branch_color = fzf_utils.ansi_from_hl("Special", "")
	return function(cb)
		for _, name in ipairs(resession.list()) do
			local path, branch = decode_name(name)
			local display
			if name:find("__branch__") then
				display = string.format("%-40s  %s", path_color(path), branch_color(branch or ""))
			else
				display = path
			end
			cb(name .. "\t" .. display)
		end
	end
end

function M.make_previewer()
	local builtin = require("fzf-lua.previewer.builtin")
	local Previewer = builtin.base:extend()

	function Previewer:new(o, opts, fzf_win)
		Previewer.super.new(self, o, opts, fzf_win)
		setmetatable(self, Previewer)
		return self
	end

	function Previewer:populate_preview_buf(entry_str)
		local tmpbuf = self:get_tmp_buffer()
		local name = entry_str:match("^([^\t]+)")
		local path, branch = decode_name(name or "")

		local lines = {
			"# " .. path,
			branch and ("**branch:** " .. branch) or "_no git repo_",
			"",
		}

		if vim.fn.isdirectory(path) == 0 then
			table.insert(lines, "_directory not found_")
			vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, lines)
			self:set_preview_buf(tmpbuf)
			vim.bo[tmpbuf].filetype = "markdown"
			return
		end

		local function git(cmd)
			return vim.fn.systemlist("git -C " .. vim.fn.shellescape(path) .. " " .. cmd .. " 2>/dev/null")
		end

		local function section(label, lang, result)
			if #result == 0 then return end
			table.insert(lines, "## " .. label)
			table.insert(lines, "```" .. lang)
			vim.list_extend(lines, result)
			table.insert(lines, "```")
			table.insert(lines, "")
		end

		section("Status", "diff", git("status --short"))
		section("Diff Stat", "diff", git("diff --stat HEAD"))
		section("Commits", "", git("log --oneline -8"))
		section("Directory", "bash", vim.fn.systemlist("ls -la " .. vim.fn.shellescape(path) .. " 2>/dev/null"))

		vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, lines)
		self:set_preview_buf(tmpbuf)
		vim.bo[tmpbuf].filetype = "markdown"
		self.win:update_preview_scrollbar()
	end

	function Previewer:gen_winopts()
		return vim.tbl_extend("force", self.winopts, { wrap = false, number = false })
	end

	return Previewer
end

return M
