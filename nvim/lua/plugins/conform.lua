vim.keymap.set("n", "<leader>fw", function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd("silent %!prettier --stdin-filepath %")
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
