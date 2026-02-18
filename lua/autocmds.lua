vim.api.nvim_create_autocmd("User", {
    pattern = "PersistedSavePre",
    callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == "nvimtree" or vim.bo[buf].filetype == "NeogitStatus" then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end
    end,
})
