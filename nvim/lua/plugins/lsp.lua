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
        opts = function(_, opts)
            local diagnostic = vim.diagnostic
            local api = vim.api

            opts.keys = opts.keys or {}
            vim.list_extend(opts.keys, {
                { "]]", false },
                { "[[", false },
            })

            -- Format on save via eslint using the official lspconfig pattern.
            -- :LspEslintFixAll runs eslint.applyAllFixes (workspace/executeCommand),
            -- which is the supported path — textDocument/formatting times out and
            -- corrupts the buffer with partial edits on errors.
            -- See ~/.local/share/nvim/lazy/nvim-lspconfig/lsp/eslint.lua docstring.
            api.nvim_create_autocmd("LspAttach", {
                group = api.nvim_create_augroup("EslintFixOnSave", { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client or client.name ~= "eslint" then
                        return
                    end
                    api.nvim_create_autocmd("BufWritePre", {
                        buffer = args.buf,
                        command = "LspEslintFixAll",
                    })
                end,
            })

            opts.diagnostics = {
                underline = false,
                virtual_text = false,
                virtual_lines = false,
                signs = {
                    text = {
                        [diagnostic.severity.ERROR] = "🆇",
                        [diagnostic.severity.WARN] = "⚠️",
                        [diagnostic.severity.INFO] = "ℹ️",
                        [diagnostic.severity.HINT] = "",
                    },
                },
                severity_sort = true,
                float = {
                    source = true,
                    header = "Diagnostics:",
                    prefix = " ",
                    border = "rounded",
                    max_height = 10,
                    max_width = 130,
                },
            }

            -- set quickfix list from diagnostics in a certain buffer, not the whole workspace
            local set_qflist = function(buf_num, severity)
                local diagnostics = nil
                diagnostics = diagnostic.get(buf_num, { severity = severity })

                local qf_items = diagnostic.toqflist(diagnostics)
                vim.fn.setqflist({}, " ", { title = "Diagnostics", items = qf_items })

                -- open quickfix by default
                vim.cmd([[copen]])
            end

            -- -- this puts diagnostics from opened files to quickfix
            -- vim.keymap.set("n", "<space>qw", diagnostic.setqflist, { desc = "Put window diagnostics to qf" })

            -- LSP
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            -- This puts diagnostics from current buffer to quickfix
            vim.keymap.set("n", "<space>cq", function()
                set_qflist(0)
            end, { desc = "See Quickfix List for Current Buffer" })

            -- Disabled: auto-popup conflicts with manual focusable float
            -- Use <leader>cd instead to open focusable diagnostic float
            -- api.nvim_create_autocmd("CursorHold", {
            --     pattern = "*",
            --     callback = function()
            --         if #vim.diagnostic.get(0) == 0 then
            --             return
            --         end
            --
            --         if not vim.b.diagnostics_pos then
            --             vim.b.diagnostics_pos = { nil, nil }
            --         end
            --
            --         local cursor_pos = api.nvim_win_get_cursor(0)
            --
            --         if not vim.deep_equal(cursor_pos, vim.b.diagnostics_pos) then
            --             diagnostic.open_float({})
            --         end
            --
            --         vim.b.diagnostics_pos = cursor_pos
            --     end,
            -- })
            opts.servers = opts.servers or {}
            opts.servers.emmet_ls = {
                filetypes = {
                    "html",
                    "css",
                    "scss",
                    "sass",
                    "javascriptreact",
                    "typescriptreact",
                    -- "vue" is intentionally removed
                },
            }

            opts.servers.stylelint_lsp = {
                filetypes = { "css", "scss", "sass" },
                settings = {
                    stylelint = {
                        validate = { "css", "scss", "sass", "postcss" },
                    },
                },
            }

            -- Configure vtsls for performance
            opts.servers.vtsls = opts.servers.vtsls or {}
            opts.servers.vtsls.settings = opts.servers.vtsls.settings or {}

            -- Disable inlay hints
            opts.servers.vtsls.settings.typescript = opts.servers.vtsls.settings.typescript or {}
            opts.servers.vtsls.settings.typescript.inlayHints = {
                enumMemberValues = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                parameterNames = { enabled = "none" },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                variableTypes = { enabled = false },
            }
            opts.servers.vtsls.settings.javascript = opts.servers.vtsls.settings.javascript or {}
            opts.servers.vtsls.settings.javascript.inlayHints = {
                enumMemberValues = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                parameterNames = { enabled = "none" },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                variableTypes = { enabled = false },
            }

            -- Performance: reduce file watcher overhead
            opts.servers.vtsls.settings.vtsls = opts.servers.vtsls.settings.vtsls or {}
            opts.servers.vtsls.settings.vtsls.experimental = {
                completion = {
                    enableServerSideFuzzyMatch = true, -- faster completions
                },
            }

            -- Performance: tsserver preferences
            opts.servers.vtsls.settings.typescript.preferences = {
                includePackageJsonAutoImports = "off", -- don't scan package.json for auto-imports
            }
            opts.servers.vtsls.settings.javascript.preferences = {
                includePackageJsonAutoImports = "off",
            }

            return opts
        end,
    },
}
