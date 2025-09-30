vim.keymap.set("n", "<leader>fw", function()
    local pos = vim.api.nvim_win_get_cursor(0)
    local buf = vim.api.nvim_get_current_buf()
    local filepath = vim.api.nvim_buf_get_name(buf)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local text = table.concat(lines, "\n")

    local output = vim.fn.systemlist("prettier --stdin-filepath " .. vim.fn.shellescape(filepath), text)
    if vim.v.shell_error == 0 and #output > 0 then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
    else
        vim.notify("Prettier failed.", vim.log.levels.ERROR)
    end

    vim.api.nvim_win_set_cursor(0, pos)
end, { desc = "Format buffer with prettier (no save, keep cursor)" })

return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            notify_on_error = false,
            default_format_opts = {
                async = true,
                timeout_ms = 3000,
            },
            formatters_by_ft = {
                lua = { "stylua" },
            },
        },
    },
}
