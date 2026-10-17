-- Paste a clipboard image into the Claude terminal over SSH.
--
-- Remotely, Claude Code's own Ctrl+V can't reach the local clipboard. Instead we
-- ask kitty for image/png over OSC 5522 (it travels through ssh), save it to a
-- file and bracketed-paste the path, which Claude Code turns into an image.
-- Protocol: https://sw.kovidgoyal.net/kitty/clipboard/

local M = {}

local ESC = "\27"
local ST = ESC .. "\\"
local CTRL_V = "\22"
local TIMEOUT_MS = 30000 -- long enough to answer kitty's permission prompt

local b64 = vim.base64.encode
-- Per-session password: approve once in kitty's prompt, not on every paste.
local PW = b64(vim.fn.sha256(tostring(vim.uv.hrtime()) .. vim.fn.getpid()))
local NAME = b64("nvim image paste")

local pending = nil

local function finish(err)
	local p = pending
	if not p then
		return
	end
	pending = nil
	pcall(vim.api.nvim_del_autocmd, p.autocmd)
	p.timer:stop()
	p.timer:close()

	if err == "ENOSYS" then
		-- No image on the clipboard: let the program handle Ctrl+V itself.
		vim.api.nvim_chan_send(p.chan, CTRL_V)
		return
	elseif err then
		vim.notify("kitty_paste: " .. err, vim.log.levels.WARN)
		return
	end

	local dir = vim.fn.stdpath("cache") .. "/clipboard-images"
	vim.fn.mkdir(dir, "p")
	local path = dir .. "/" .. os.date("%Y%m%d-%H%M%S") .. ".png"
	local f = assert(io.open(path, "wb"))
	f:write(table.concat(p.chunks))
	f:close()
	-- Bracketed paste so Claude Code treats it like a dropped image path.
	vim.api.nvim_chan_send(p.chan, ESC .. "[200~" .. path .. ESC .. "[201~")
end

local function on_response(ev)
	local meta, payload = ev.data.sequence:match("^\27%]5522;([^;\27\7]*);?([^\27\7]*)")
	if not pending or not meta or not meta:find("type=read", 1, true) then
		return
	end
	local status = meta:match("status=(%u+)")
	if status == "DATA" then
		-- Chunks are padded individually, so decode each one on its own.
		table.insert(pending.chunks, vim.base64.decode(payload))
	elseif status == "DONE" then
		finish(#pending.chunks == 0 and "ENOSYS" or nil)
	elseif status ~= "OK" then
		finish(status)
	end
end

--- Request image/png from kitty and paste its path into the terminal `chan`.
function M.paste(chan)
	if pending then
		return
	end
	pending = { chan = chan, chunks = {}, timer = vim.uv.new_timer() }
	pending.autocmd = vim.api.nvim_create_autocmd("TermResponse", { callback = on_response })
	pending.timer:start(
		TIMEOUT_MS,
		0,
		vim.schedule_wrap(function()
			finish("no reply from terminal")
		end)
	)
	vim.api.nvim_ui_send(ESC .. "]5522;type=read:pw=" .. PW .. ":name=" .. NAME .. ";" .. b64("image/png") .. ST)
end

local function in_kitty()
	return vim.env.KITTY_WINDOW_ID ~= nil or vim.env.TERM == "xterm-kitty"
end

function M.setup()
	vim.api.nvim_create_autocmd("TermOpen", {
		pattern = "term://*claude*",
		callback = function(ev)
			-- Locally Claude Code reads the clipboard itself; only take over over SSH.
			if not (vim.env.SSH_CONNECTION and in_kitty()) then
				return
			end
			vim.keymap.set("t", "<C-v>", function()
				M.paste(vim.bo[ev.buf].channel)
			end, { buffer = ev.buf, desc = "Paste clipboard image via kitty OSC 5522" })
		end,
	})
end

return M
