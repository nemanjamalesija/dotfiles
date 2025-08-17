vim.api.nvim_create_user_command("ConformDisable", function(args)
    if args.bang then
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable conform-autoformat-on-save",
    bang = true,
})

vim.api.nvim_create_user_command("ConformEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable conform-autoformat-on-save",
})

return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            notify_on_error = false,
            default_format_opts = {
                async = true,
                timeout_ms = 500,
                lsp_format = "fallback",
            },
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                vue = { "prettier" },
                vuetypescript = { "prettier" },
                typescriptreact = { "prettier" },
            },
        },
    },
}
