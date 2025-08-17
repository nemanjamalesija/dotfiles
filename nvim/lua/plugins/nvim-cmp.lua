-- ~/.config/nvim/lua/plugins/completion.lua

return {
    {
        "hrsh7th/nvim-cmp",
        enabled = true,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        opts = function(_, opts)
            local cmp = require("cmp")

            -- Ensure completion triggers automatically
            opts.completion = {
                autocomplete = {
                    cmp.TriggerEvent.TextChanged,
                    cmp.TriggerEvent.InsertEnter,
                },
                completeopt = "menu,menuone,noselect",
            }

            -- Configure sources (order matters for priority)
            opts.sources = cmp.config.sources({
                { name = "nvim_lsp", priority = 1000 },
                { name = "luasnip", priority = 750 },
                { name = "buffer", priority = 500 },
                { name = "path", priority = 250 },
            })

            -- Performance settings
            opts.performance = {
                debounce = 60,
                throttle = 30,
                fetching_timeout = 500,
                confirm_resolve_timeout = 80,
                async_budget = 1,
                max_view_entries = 200,
            }

            -- Window styling
            opts.window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            }

            return opts
        end,
        config = function(_, opts)
            local cmp = require("cmp")
            cmp.setup(opts)

            -- Setup cmdline completion
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
                matching = { disallow_symbol_nonprefix_matching = false },
            })
        end,
    },
}
