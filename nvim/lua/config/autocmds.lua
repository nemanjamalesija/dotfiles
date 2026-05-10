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
    pattern = { "markdown", "text", "gitcommit" },
    callback = function()
        vim.opt_local.spell = false
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
        vim.schedule(function()
            local bufs = vim.fn.getbufinfo({ buflisted = 1 })
            if #bufs <= 10 then
                return
            end
            table.sort(bufs, function(a, b)
                return (a.lastused or 0) < (b.lastused or 0)
            end)
            local current = vim.api.nvim_get_current_buf()
            for _, buf in ipairs(bufs) do
                if
                    buf.bufnr ~= current
                    and #buf.windows == 0
                    and buf.changed == 0
                then
                    pcall(vim.cmd, "bdelete " .. buf.bufnr)
                    break
                end
            end
        end)
    end,
})
