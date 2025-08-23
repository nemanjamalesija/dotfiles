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
                    "ts_ls", -- TypeScript with Vue plugin
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

            -- Get Vue Language Server path for TypeScript plugin
            local mason_registry = require("mason-registry")
            local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
                .. "/node_modules/@vue/language-server"

            -- TypeScript with Vue plugin (handles TS/JS/Vue)
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
                init_options = {
                    plugins = {
                        {
                            name = "@vue/typescript-plugin",
                            location = vue_language_server_path,
                            languages = { "vue" },
                        },
                    },
                },
                filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
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

            -- HTML LSP server
            lspconfig.html.setup({
                capabilities = capabilities,
                filetypes = { "html", "vue" },
            })

            -- Tailwind CSS LSP server
            lspconfig.tailwindcss.setup({
                capabilities = capabilities,
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
            })

            -- Emmet LSP server
            lspconfig.emmet_ls.setup({
                capabilities = capabilities,
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
            })

            -- Lua LSP server
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })

            -- SASS LSP server
            lspconfig.somesass_ls.setup({
                capabilities = capabilities,
            })

            -- Keymaps
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, { desc = "Find references" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
        end,
    },
}
