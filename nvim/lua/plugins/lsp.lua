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
                    "eslint",
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

            -- Common on_attach function to disable LSP formatting
            local on_attach = function(client, bufnr)
                -- Disable LSP formatting in favor of conform.nvim
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
            end

            -- Eslint (keep auto-fix functionality, but disable formatting)
            lspconfig.eslint.setup({
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    on_attach(client, bufnr) -- Disable formatting

                    -- Keep ESLint auto-fix on save
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.cmd("EslintFixAll")
                        end,
                    })
                end,
            })

            -- Stylelint (remove formatting, keep linting)
            lspconfig.stylelint_lsp.setup({
                capabilities = capabilities,
                on_attach = on_attach, -- Disable formatting
                settings = {
                    stylelintplus = {
                        autoFixOnSave = false, -- Disable auto-fix, let conform handle it
                        autoFixOnFormat = false,
                    },
                },
                filetypes = { "css", "scss", "less", "sass" },
            })

            -- PHP
            lspconfig.intelephense.setup({
                capabilities = capabilities,
                on_attach = on_attach, -- Disable formatting
                filetypes = { "php", "view", "template", "twig" }, -- Added twig support
                settings = {
                    intelephense = {
                        files = {
                            associations = { "*.php", "*.view", "*.template", "*.twig" }, -- Added twig files
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
                on_attach = on_attach, -- Disable formatting
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
                on_attach = on_attach, -- Disable formatting
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
                on_attach = on_attach, -- Disable formatting
                filetypes = { "html" },
            })

            -- Tailwind CSS LSP server
            lspconfig.tailwindcss.setup({
                capabilities = capabilities,
                on_attach = on_attach, -- Disable formatting
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
                on_attach = on_attach, -- Disable formatting
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
                on_attach = on_attach, -- Disable formatting
            })

            -- SASS LSP server
            lspconfig.somesass_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach, -- Disable formatting
            })

            -- Keymaps
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, { desc = "Find references" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
        end,
    },
}
