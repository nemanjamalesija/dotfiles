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
                    "tailwindcss",
                    "lua_ls",
                    "emmet_ls",
                    "eslint",
                    "stylelint_lsp",
                    "intelephense",
                },
                automatic_installation = true,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            inlay_hints = { enabled = false },
        },
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            local on_attach = function(client, bufnr)
                client.server_capabilities.documentFormattingProvider = true
                client.server_capabilities.documentRangeFormattingProvider = true
            end

            local lspconfig = require("lspconfig")

            lspconfig.eslint.setup({
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    on_attach(client, bufnr)

                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.cmd("EslintFixAll")
                        end,
                    })
                end,
            })

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
                filetypes = { "css", "scss", "sass", "less" },
            }

            -- HTML LSP
            vim.lsp.config.html = {
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { "html" },
            }

            -- Tailwind CSS LSP
            -- vim.lsp.config.tailwindcss = {
            --     capabilities = capabilities,
            --     on_attach = on_attach,
            --     filetypes = {
            --         "html",
            --         "css",
            --         "scss",
            --         "javascript",
            --         "javascriptreact",
            --         "typescript",
            --         "typescriptreact",
            --         "vue",
            --     },
            -- }

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

            local vue_ls_path = vim.fn.expand("$MASON/packages/vue-language-server")
            local vue_plugin_path = vue_ls_path .. "/node_modules/@vue/language-server"

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

            -- Twig LSP
            lspconfig.twiggy_language_server.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { "twig" },
                root_dir = lspconfig.util.root_pattern(".git", "."),
            })

            -- Keymaps
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, { desc = "Find references" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
        end,
    },
}
