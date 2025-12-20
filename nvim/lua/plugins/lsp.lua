return {
    { "mason-org/mason.nvim" },
    {
        "mason-org/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "html",
                    "emmet_ls",
                    "cssls",
                    "vtsls",
                    "vue_ls",
                    "eslint",
                    "stylelint_lsp",
                    "jsonls",
                    "marksman",
                    -- "tailwindcss",
                    -- "intelephense",
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
            vim.lsp.set_log_level("off")

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            local on_attach = function(client)
                client.server_capabilities.documentFormattingProvider = true
                client.server_capabilities.documentRangeFormattingProvider = true
            end

            local lspconfig = require("lspconfig")

            lspconfig.eslint.setup({
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    on_attach(client)

                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.cmd("EslintFixAll")
                        end,
                    })
                end,
                settings = {
                    run = "onSave",
                    workingDirectory = { mode = "auto" },
                    experimental = {
                        useFlatConfig = true,
                    },
                },
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

            --JSON
            vim.lsp.config.jsonls = {
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { "json", "jsonc" },
            }

            -- HTML LSP
            vim.lsp.config.html = {
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { "html" },
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

            -- vtsls (TypeScript/JavaScript)
            vim.lsp.config.vtsls = {
                capabilities = capabilities,
                on_attach = function(client)
                    client.server_capabilities.documentHighlightProvider = false
                    on_attach(client)
                end,
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "typescript",
                    "typescriptreact",
                    "typescript.tsx",
                    "vue",
                },
            }

            -- Twig LSP
            lspconfig.twiggy_language_server.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { "twig" },
                root_dir = lspconfig.util.root_pattern(".git", "."),
            })

            -- Markdown LSP
            vim.lsp.config.markdown = {
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { "markdown" },
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

            -- PHP Intelephense
            -- vim.lsp.config.intelephense = {
            --     capabilities = capabilities,
            --     on_attach = on_attach,
            --     settings = {
            --         intelephense = {
            --             stubs = {
            --                 "symfony",
            --                 "Core",
            --                 "PDO",
            --                 "json",
            --                 "mbstring",
            --                 "curl",
            --                 "openssl",
            --             },
            --         },
            --     },
            --     filetypes = { "php" },
            -- }

            -- Keymaps
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, { desc = "Find references" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
        end,
    },
}
