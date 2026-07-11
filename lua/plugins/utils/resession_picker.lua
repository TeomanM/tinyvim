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
		-- First pass: decode all entries and find the widest path for column alignment.
		local entries = {}
		local width = 0
		for _, name in ipairs(resession.list()) do
			local path, branch = decode_name(name)
			entries[#entries + 1] = { name = name, path = path, branch = branch }
			width = math.max(width, vim.fn.strdisplaywidth(path))
		end

		-- Second pass: pad the plain path (so ANSI codes don't skew the column), then colorize.
		for _, e in ipairs(entries) do
			local padded = e.path .. string.rep(" ", width - vim.fn.strdisplaywidth(e.path))
			local display = path_color(padded)
			if e.branch then
				display = display .. "  " .. branch_color(e.branch)
			end
			cb(e.name .. "\t" .. display)
		end
		cb(nil)
	end
end

-- Walk a resession window-layout tree, collecting the win leaves in order.
-- The tree is `{"leaf", win}` or `{"row"/"col", subtree, subtree, ...}`.
local function collect_wins(tree, out)
	if type(tree) ~= "table" then
		return out
	end
	if tree[1] == "leaf" then
		out[#out + 1] = tree[2]
	else
		for i = 2, #tree do
			collect_wins(tree[i], out)
		end
	end
	return out
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

		local session_file = string.format("%s/session/%s.json", vim.fn.stdpath("data"), name or "")
		local data = nil
		local read_ok, contents = pcall(vim.fn.readfile, session_file)
		if read_ok and #contents > 0 then
			local decode_ok, decoded = pcall(vim.json.decode, table.concat(contents, "\n"))
			if decode_ok and type(decoded) == "table" then
				data = decoded
			end
		end

		local tabs = data and data.tabs or {}

		if #tabs == 0 then
			table.insert(lines, "_no tabs in session_")
		end

		for i, tab in ipairs(tabs) do
			local cwd = tab.cwd or (data.global and data.global.cwd) or path
			table.insert(lines, string.format("## Tab %d: %s", i, cwd))
			table.insert(lines, "")

			local base = cwd:gsub("/$", "") .. "/"
			local function relname(bufname)
				bufname = bufname or ""
				if bufname == "" then
					return "[No Name]"
				end
				return bufname:sub(1, #base) == base and bufname:sub(#base + 1) or bufname
			end

			local wins = collect_wins(tab.wins, {})
			if #wins == 0 then
				table.insert(lines, "_no windows_")
			else
				for _, win in ipairs(wins) do
					local marker = win.current and "**→ " or "- "
					local close = win.current and "**" or ""
					table.insert(lines, marker .. relname(win.bufname) .. close)
				end
			end
			table.insert(lines, "")
		end

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
