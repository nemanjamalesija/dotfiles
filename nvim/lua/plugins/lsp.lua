return {
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            local diagnostic = vim.diagnostic
            local api = vim.api

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
                    border = "single",
                    max_height = 10,
                    max_width = 130,
                    close_events = { "CursorMoved", "BufLeave", "WinLeave", "InsertEnter" },
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

            -- automatically show diagnostic in float win for current line
            api.nvim_create_autocmd("CursorHold", {
                pattern = "*",
                callback = function()
                    if #vim.diagnostic.get(0) == 0 then
                        return
                    end

                    if not vim.b.diagnostics_pos then
                        vim.b.diagnostics_pos = { nil, nil }
                    end

                    local cursor_pos = api.nvim_win_get_cursor(0)

                    if not vim.deep_equal(cursor_pos, vim.b.diagnostics_pos) then
                        diagnostic.open_float({})
                    end

                    vim.b.diagnostics_pos = cursor_pos
                end,
            })
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

            -- Completely disable vue_ls
            opts.servers.vue_ls = opts.servers.vue_ls or {}
            opts.servers.vue_ls.enabled = false

            -- Disable inlay hints for vtsls
            opts.servers.vtsls = opts.servers.vtsls or {}
            opts.servers.vtsls.settings = opts.servers.vtsls.settings or {}
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

            return opts
        end,
    },
}
