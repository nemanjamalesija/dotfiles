-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
--
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "text", "gitcommit" }, -- Adjust file types as needed
    callback = function()
        vim.opt.spell = false
    end,
})

if vim.env.TMUX then
    local tmux_pane = vim.env.TMUX_PANE

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        callback = function()
            local file = vim.fn.expand("%:.")
            if file ~= "" then
                vim.fn.jobstart(string.format("tmux set -t %s @current_file '%s'", tmux_pane, file), { detach = true })
            end
        end,
    })
end

vim.api.nvim_create_autocmd("BufAdd", {
    callback = function()
        local bufs = vim.fn.getbufinfo({ buflisted = 1 })
        if #bufs > 10 then
            for _, buf in ipairs(bufs) do
                if buf.bufnr ~= vim.api.nvim_get_current_buf() then
                    vim.cmd("bdelete " .. buf.bufnr)
                    break
                end
            end
        end
    end,
})
