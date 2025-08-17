return {
    { "williamboman/mason.nvim" },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded",
                max_width = 80,
                max_height = 20,
            })

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "ts_ls",
                    "volar",
                    "intelephense",
                    "html",
                    "cssls",
                    "tailwindcss",
                    "somesass_ls",
                    "lua_ls",
                    "emmet_ls",
                    "stylelint_lsp",
                },
                automatic_installation = true,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            inlay_hints = { enabled = false },
            document_highlight = {
                enabled = false,
            },
        },
        config = function()
            local lspconfig = require("lspconfig")

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            local ts_error = require("ts-error-translator")
            ts_error.setup()

            -- Eslint
            lspconfig.eslint.setup({
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.cmd("EslintFixAll")
                        end,
                    })
                end,
            })

            -- Stylelint
            lspconfig.stylelint_lsp.setup({
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({
                                filter = function(client)
                                    return client.name == "stylelint_lsp"
                                end,
                                async = false,
                            })
                        end,
                    })
                end,
                settings = {
                    stylelintplus = {
                        autoFixOnSave = true,
                        autoFixOnFormat = true,
                    },
                },
                filetypes = { "css", "scss", "less", "sass" },
            })

            -- PHP
            lspconfig.intelephense.setup({
                capabilities = capabilities,
                filetypes = { "php", "view", "template" }, -- Add your custom filetypes
                settings = {
                    intelephense = {
                        files = {
                            associations = { "*.php", "*.view", "*.template" }, -- Associate files
                        },
                    },
                },
            })

            -- Typescript LSP server
            --[[  lspconfig.ts_ls.setup({}) ]]

            -- Volar LSP server
            lspconfig.volar.setup({
                capabilities = capabilities,
                filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
                init_options = {
                    vue = {
                        hybridMode = false,
                    },
                },
            })

            -- CSS LSP server
            lspconfig.cssls.setup({
                capabilities = capabilities,
                settings = {
                    css = {
                        validate = true,
                        completion = {
                            completePropertyWithSemicolon = true,
                            triggerPropertyValueCompletion = true,
                        },
                    },
                    scss = {
                        validate = true,
                        completion = {
                            completePropertyWithSemicolon = true,
                            triggerPropertyValueCompletion = true,
                        },
                    },
                    less = {
                        validate = true,
                        completion = {
                            completePropertyWithSemicolon = true,
                            triggerPropertyValueCompletion = true,
                        },
                    },
                },
            })

            -- Keymaps
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find references" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
        end,
    },
}
