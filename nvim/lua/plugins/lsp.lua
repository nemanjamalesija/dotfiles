return {
    { "mason-org/mason.nvim" },
    {
        "mason-org/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "ts_ls",
                    "html",
                    "cssls",
                    "somesass_ls",
                    "tailwindcss",
                    "lua_ls",
                    "emmet_ls",
                    "eslint",
                    "stylelint_lsp",
                    "intelephense",
                    "vue_ls",
                },
                automatic_installation = true,
            })
        end,
    },
    {
        "MunifTanjim/eslint.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("eslint").setup({
                code_actions = {
                    enable = true,
                    apply_on_save = {
                        enable = true,
                        types = { "directive", "problem", "suggestion", "layout" },
                    },
                },
                diagnostics = {
                    enable = true,
                    report_unused_disable_directives = false,
                    run_on = "type",
                },
                filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
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
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            local ts_error = require("ts-error-translator")
            ts_error.setup()

            local lsp_format_on_save_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = false })

            local on_attach = function(client, bufnr)
                client.server_capabilities.documentFormattingProvider = true
                client.server_capabilities.documentRangeFormattingProvider = true

                vim.api.nvim_clear_autocmds({ group = lsp_format_on_save_group, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = lsp_format_on_save_group,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = bufnr, async = false })
                    end,
                })
            end
            -- Get Vue Language Server path for TypeScript plugin using Mason v2 API
            local vue_ls_path = vim.fn.expand("$MASON/packages/vue-language-server")
            local vue_plugin_path = vue_ls_path .. "/node_modules/@vue/language-server"

            -- Stylelint
            vim.lsp.config.stylelint_lsp = {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    stylelintplus = {
                        autoFixOnSave = true,
                        autoFixOnFormat = true,
                    },
                },
                filetypes = { "css", "scss", "less", "sass" },
            }

            -- TypeScript with Vue plugin
            vim.lsp.config.ts_ls = {
                capabilities = capabilities,
                on_attach = on_attach,
                init_options = {
                    plugins = {
                        {
                            name = "@vue/typescript-plugin",
                            location = vue_plugin_path,
                            languages = { "vue" },
                        },
                    },
                },
                filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
            }

            -- HTML LSP
            vim.lsp.config.html = {
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { "html" },
            }

            -- Tailwind CSS LSP
            vim.lsp.config.tailwindcss = {
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = {
                    "html",
                    "css",
                    "scss",
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact",
                    "vue",
                },
            }

            -- Emmet LSP
            vim.lsp.config.emmet_ls = {
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = {
                    "html",
                    "css",
                    "scss",
                },
            }

            -- Lua LSP
            vim.lsp.config.lua_ls = {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                end,
            }

            -- PHP Intelephense
            vim.lsp.config.intelephense = {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    intelephense = {
                        stubs = {
                            "symfony",
                            "Core",
                            "PDO",
                            "json",
                            "mbstring",
                            "curl",
                            "openssl",
                        },
                    },
                },
                filetypes = { "php" },
            }

            -- Keymaps
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, { desc = "Find references" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
        end,
    },
}
