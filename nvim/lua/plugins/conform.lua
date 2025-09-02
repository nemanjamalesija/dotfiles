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

-- vim.keymap.set("n", "<leader>cf", function()
--     require("conform").format({ formatters = { "eslint" }, force = true })
-- end, { desc = "Format with biome" })

vim.api.nvim_set_keymap(
    "n",
    "<leader>fw",
    ":!biome format --write=false %<CR>",
    { noremap = true, silent = true, desc = "Format with biome (no save)" }
)

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
                -- Web languages - KEEP ESLint for auto-save (fixes + formats)
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
            },
            -- Custom formatters
            formatters = {
                biome = {
                    command = "biome",
                    args = { "format", "--stdin-file-path", "$FILENAME" },
                    stdin = true,
                    cwd = function()
                        return vim.fn.expand("%:p:h")
                    end,
                },
            },
        },
    },
}
