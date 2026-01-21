return {
    -- {
    --     "mason-org/mason-lspconfig.nvim",
    --     opts = function(_, opts)
    --         opts.ensure_installed = opts.ensure_installed or {}
    --         -- Remove vue_ls if it exists
    --         opts.ensure_installed = vim.tbl_filter(function(server)
    --             return server ~= "vue_ls"
    --         end, opts.ensure_installed)
    --     end,
    -- },
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            opts.diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = false,
                virtual_lines = false,
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "E",
                        [vim.diagnostic.severity.WARN] = "W",
                        [vim.diagnostic.severity.HINT] = "H",
                        [vim.diagnostic.severity.INFO] = "I",
                    },
                },
            }
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

            -- -- Disable volar too (same binary as vue_ls)
            -- opts.servers.volar = opts.servers.volar or {}
            -- opts.servers.volar.enabled = false

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
