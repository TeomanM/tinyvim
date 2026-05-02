local map = vim.keymap.set

-- general mappings
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

-- bufferline, cycle buffers
map("n", "<Tab>", "<cmd> BufferLineCycleNext <CR>")
map("n", "<S-Tab>", "<cmd> BufferLineCyclePrev <CR>")

-- Close buffer without disturbing window layout.
-- Plain :bdelete also closes the window holding the buffer, which lets
-- sidebars like neo-tree become the sole window and expand full-width.
-- Instead: swap each window showing this buffer to a different buffer
-- first, THEN delete the buffer — windows stay, layout stays.
-- Modified check happens before any window swap so Cancel is a true no-op.
local function close_buf(buf)
	buf = buf or vim.api.nvim_get_current_buf()

	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	if vim.bo[buf].modified then
		local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname(buf)), "&Save\n&Discard\n&Cancel", 3)
		if choice == 1 then
			local ok, err = pcall(vim.api.nvim_buf_call, buf, vim.cmd.write)
			if not ok then
				vim.notify("Could not save buffer: " .. tostring(err), vim.log.levels.ERROR)
				return
			end
		elseif choice == 2 then
			-- fall through; force=true set at deletion
		else
			return -- Cancel or <Esc>
		end
	end

	-- Prefer the alternate buffer (`#`) as the replacement — feels natural,
	-- like `:b#`. Fall back to scanning all listed buffers.
	local alt = vim.fn.bufnr("#")
	local target
	if alt ~= -1 and alt ~= buf and vim.fn.buflisted(alt) == 1 then
		target = alt
	else
		for _, b in ipairs(vim.api.nvim_list_bufs()) do
			if b ~= buf and vim.fn.buflisted(b) == 1 then
				target = b
				break
			end
		end
	end

	-- Replace the buffer in every window showing it. If nothing suitable was
	-- found (last real buffer), create a fresh empty listed buffer.
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == buf then
			vim.api.nvim_win_set_buf(win, target or vim.api.nvim_create_buf(true, false))
		end
	end

	-- force=true only when user chose Discard (modified still true after swap)
	vim.api.nvim_buf_delete(buf, { force = vim.bo[buf].modified })
end

map("n", "<leader>x", close_buf, { desc = "Close buffer without disturbing window layout" })

-- Intercept :q so it uses the layout-safe close instead of Vim's default
-- window-closing path. error(...,0) aborts the :q; Neovim catches it at
-- the autocmd boundary without printing anything to the user.
vim.api.nvim_create_autocmd("QuitPre", {
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		if vim.bo[buf].buftype ~= "" then
			return
		end
		close_buf(buf)
		error("close_buf: handled", 0)
	end,
})

map("n", "<leader>/", "gcc", { remap = true })
map("v", "<leader>/", "gc", { remap = true })

-- format
map({ "n", "x" }, "<leader>fm", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })

-- terminal
map("t", "<C-q>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", ";", ":", { desc = "CMD enter command mode" })

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<esc>", ":noh<cr>", opts)
