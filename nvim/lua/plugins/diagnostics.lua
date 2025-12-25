return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = false,
                virtual_lines = false,
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "E",
                        [vim.diagnostic.severity.WARN] = "W",
                        [vim.diagnostic.severity.HINT] = "H",
                        [vim.diagnostic.severity.INFO] = "I",
                    },
                },
            },
        },
    },
}
