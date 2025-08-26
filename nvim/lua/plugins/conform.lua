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

vim.keymap.set("n", "<leader>cf", function()
    require("conform").format({ formatters = { "prettier" }, force = true })
end, { desc = "Format with prettier" })

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
                -- Web languages
                lua = { "stylua" },
                javascript = { "eslint" },
                typescript = { "eslint" },
                vue = { "eslint" },
                typescriptreact = { "eslint" },
                javascriptreact = { "eslint" },

                -- Stylesheets
                css = { "stylelint" },
                scss = { "stylelint" },
                sass = { "stylelint" },
                less = { "stylelint" },

                -- Markup
                html = { "prettier" },

                -- Config files
                json = { "prettier" },
                yaml = { "prettier" },
                toml = { "taplo" },

                -- Markdown
                markdown = { "prettier" },
            },
            -- Custom formatters (if needed)
            formatters = {
                -- stylelint = {
                --     command = "stylelint",
                --     args = { "--fix", "--stdin", "--stdin-filename", "$FILENAME" },
                --     stdin = true,
                -- },
                prettier = {
                    command = "prettier",
                    args = { "--stdin-filepath", "$FILENAME" },
                    stdin = true,
                },
            },
        },
    },
}
