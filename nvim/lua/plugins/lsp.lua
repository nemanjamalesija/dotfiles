return {
    {
        "stevearc/conform.nvim",
        opts = {
            -- Don't let conform fall back to vim.lsp.buf.format(). Vue files have
            -- vue_ls + vtsls + eslint all attached; an unfiltered LSP format call
            -- picks whichever responds first and races our :LspEslintFixAll autocmd.
            -- eslint is now the sole formatter for js/ts/vue (via the BufWritePre
            -- autocmd above); conform stays in charge of css/scss/sass via prettier.
            default_format_opts = {
                lsp_format = "never",
            },
            formatters_by_ft = {
                css = { "prettier" },
                scss = { "prettier" },
                sass = { "prettier" },
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        -- NOTE: LSP hover and signature help borders are now configured in noice.lua
        -- noice.nvim handles these UI elements and overrides vim.lsp.handlers
        -- See nvim/lua/plugins/noice.lua for hover/signature configuration
        init = function()
            -- Format on save via eslint using the official lspconfig pattern.
            -- :LspEslintFixAll runs eslint.applyAllFixes (workspace/executeCommand),
            -- which is the supported path — textDocument/formatting times out and
            -- corrupts the buffer with partial edits on errors.
            -- See ~/.local/share/nvim/lazy/nvim-lspconfig/lsp/eslint.lua docstring.
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("EslintFixOnSave", { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client or client.name ~= "eslint" then
                        return
                    end
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = args.buf,
                        command = "LspEslintFixAll",
                    })
                end,
            })
        end,
        opts = {
            diagnostics = {
                underline = false,
                virtual_text = false,
                virtual_lines = false,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "🆇",
                        [vim.diagnostic.severity.WARN] = "⚠️",
                        [vim.diagnostic.severity.INFO] = "ℹ️",
                        [vim.diagnostic.severity.HINT] = "",
                    },
                },
                severity_sort = true,
                float = {
                    source = true,
                    header = "Diagnostics:",
                    prefix = " ",
                    max_height = 10,
                    max_width = 130,
                },
            },
            servers = {
                ["*"] = {
                    keys = {
                        { "<leader>gd", vim.lsp.buf.definition, desc = "Go to definition" },
                    },
                },
                emmet_ls = {
                    filetypes = {
                        "html",
                        "css",
                        "scss",
                        "sass",
                        "javascriptreact",
                        "typescriptreact",
                        -- "vue" is intentionally removed
                    },
                },
                stylelint_lsp = {
                    filetypes = { "css", "scss", "sass" },
                    settings = {
                        stylelint = {
                            validate = { "css", "scss", "sass", "postcss" },
                        },
                    },
                },
                vtsls = {
                    settings = {
                        -- Disable inlay hints
                        typescript = {
                            inlayHints = {
                                enumMemberValues = { enabled = false },
                                functionLikeReturnTypes = { enabled = false },
                                parameterNames = { enabled = "none" },
                                parameterTypes = { enabled = false },
                                propertyDeclarationTypes = { enabled = false },
                                variableTypes = { enabled = false },
                            },
                            -- Performance: tsserver preferences
                            preferences = {
                                includePackageJsonAutoImports = "off", -- don't scan package.json for auto-imports
                            },
                        },
                        javascript = {
                            inlayHints = {
                                enumMemberValues = { enabled = false },
                                functionLikeReturnTypes = { enabled = false },
                                parameterNames = { enabled = "none" },
                                parameterTypes = { enabled = false },
                                propertyDeclarationTypes = { enabled = false },
                                variableTypes = { enabled = false },
                            },
                            preferences = {
                                includePackageJsonAutoImports = "off",
                            },
                        },
                        -- Performance: reduce file watcher overhead
                        vtsls = {
                            experimental = {
                                completion = {
                                    enableServerSideFuzzyMatch = true, -- faster completions
                                },
                            },
                        },
                    },
                },
            },
        },
    },
}
