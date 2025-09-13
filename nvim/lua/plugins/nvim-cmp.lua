return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "onsails/lspkind.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        opts = function(_, opts)
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            -- Theme-adaptive highlight groups that work with both light and dark themes
            vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { strikethrough = true, link = "Comment" })
            vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bold = true, link = "Function" })
            vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { bold = true, link = "Function" })
            vim.api.nvim_set_hl(0, "CmpItemMenu", { italic = true, link = "Comment" })
            vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { link = "String" })

            -- Enhanced formatting with lspkind and Copilot icon
            opts.formatting = {
                fields = { "abbr", "kind", "menu" },
                format = function(entry, vim_item)
                    local lspkind = require("lspkind")

                    -- Apply lspkind formatting first
                    vim_item = lspkind.cmp_format({
                        mode = "text",
                        -- maxwidth = 50,
                        -- ellipsis_char = "...",
                        show_labelDetails = true,
                        symbol_map = {
                            Copilot = "",
                        },
                    })(entry, vim_item)

                    -- -- Custom menu labels
                    -- local menu_map = {
                    --     copilot = "",
                    --     nvim_lsp = "[LSP]",
                    --     luasnip = "",
                    --     buffer = "[Buf]",
                    --     path = "[Path]",
                    --     cmdline = "[Cmd]",
                    -- }
                    --
                    -- vim_item.menu = menu_map[entry.source.name] or "[?]"

                    -- Special handling for semicolon-prefixed snippets
                    if entry.source.name == "luasnip" and vim_item.abbr:match("^;") then
                        vim_item.abbr = vim_item.abbr:gsub("^;", "⌘ ") -- Replace ; with a nice symbol
                    end

                    return vim_item
                end,
            }

            opts.sources = cmp.config.sources({
                { name = "luasnip" },
                { name = "nvim_lsp" },
                { name = "copilot" },
            }, {
                { name = "buffer" },
            })

            opts.sorting = {
                priority_weight = 2,
                comparators = {
                    function(entry1, entry2)
                        local source1 = entry1.source.name
                        local source2 = entry2.source.name

                        local priority_order = {
                            luasnip = 1,
                            nvim_lsp = 2,
                            copilot = 3,
                            buffer = 4,
                            path = 5,
                        }

                        local priority1 = priority_order[source1] or 999
                        local priority2 = priority_order[source2] or 999

                        if priority1 ~= priority2 then
                            return priority1 < priority2
                        end

                        -- If same priority, continue with normal sorting
                        return nil
                    end,

                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.score,
                    cmp.config.compare.recently_used,
                    cmp.config.compare.locality,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            }

            opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
                -- Trigger completion when typing semicolon
                [";"] = cmp.mapping(function(fallback)
                    if not cmp.visible() then
                        cmp.complete()
                    end
                    fallback()
                end, { "i" }),

                ["<CR>"] = cmp.mapping(function(fallback)
                    fallback()
                end, { "i" }),

                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-f>"] = cmp.mapping.scroll_docs(-4),
                ["<C-b>"] = cmp.mapping.scroll_docs(4),
            })

            opts.experimental = opts.experimental or {}
            opts.experimental.ghost_text = false

            return opts
        end,
    },
}
