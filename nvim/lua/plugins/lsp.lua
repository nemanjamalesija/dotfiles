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
                },
                automatic_installation = true,
            })
        end,
    },
    -- {
    --     "MunifTanjim/eslint.nvim",
    --     dependencies = { "nvim-lua/plenary.nvim" },
    --     config = function()
    --         require("eslint").setup({
    --             code_actions = {
    --                 enable = true,
    --                 apply_on_save = {
    --                     enable = true,
    --                     types = { "directive", "problem", "suggestion", "layout" },
    --                 },
    --             },
    --             diagnostics = {
    --                 enable = true,
    --                 report_unused_disable_directives = false,
    --                 run_on = "type",
    --             },
    --             -- FIXED: Explicitly exclude Vue files
    --             filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    --             -- Prevent ESLint from attaching to Vue files
    --             on_attach = function(client, bufnr)
    --                 local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
    --                 if ft == "vue" then
    --                     vim.schedule(function()
    --                         vim.lsp.buf_detach_client(bufnr, client.id)
    --                     end)
    --                     return false
    --                 end
    --             end,
    --         })
    --     end,
    -- },
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

            -- FIXED: Create buffer-specific autocmd groups to prevent conflicts
            local on_attach = function(client, bufnr)
                client.server_capabilities.documentFormattingProvider = true
                client.server_capabilities.documentRangeFormattingProvider = true

                -- Use buffer-specific group name
                local group_name = "LspFormatOnSave_" .. bufnr
                local group = vim.api.nvim_create_augroup(group_name, { clear = true })

                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = group,
                    buffer = bufnr,
                    callback = function()
                        local view = vim.fn.winsaveview()
                        vim.lsp.buf.format({ bufnr = bufnr, async = false })
                        vim.fn.winrestview(view)
                    end,
                })
            end

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

            -- TypeScript with Vue plugin (Takeover Mode)
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
                    "vue",
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
