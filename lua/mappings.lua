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
map("n", "<leader>x", function()
	local buf = vim.api.nvim_get_current_buf()

	-- Prefer the alternate buffer (`#`, i.e. the last-edited one) as the
	-- replacement — feels natural, like `:b#`. Fall back to scanning all
	-- listed buffers for any other real file buffer.
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

	-- Replace the doomed buffer in every window that's currently showing it.
	-- If nothing suitable was found (this was the last real buffer), create
	-- a fresh empty listed buffer so the window has *something* to display.
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == buf then
			vim.api.nvim_win_set_buf(win, target or vim.api.nvim_create_buf(true, false))
		end
	end

	-- pcall: deletion can fail (e.g. unsaved changes)
	-- swallow the error rather than crashing
	pcall(vim.api.nvim_buf_delete, buf, {})
end, { desc = "Close buffer without disturbing window layout" })

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
