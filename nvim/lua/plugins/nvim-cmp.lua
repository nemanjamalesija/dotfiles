return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "onsails/lspkind.nvim",
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

            -- Enhanced window styling with colorscheme-aware highlights
            opts.window = {
                completion = {
                    border = "rounded",
                    winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
                    scrolloff = 0,
                    col_offset = 0,
                    side_padding = 1,
                    scrollbar = true,
                },
                documentation = {
                    border = "rounded",
                    winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
                    max_height = 15,
                    max_width = 60,
                },
            }

            -- Enhanced formatting with lspkind and Copilot icon
            opts.formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    local lspkind = require("lspkind")

                    -- Apply lspkind formatting first
                    vim_item = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                        show_labelDetails = true,
                        symbol_map = {
                            Copilot = "",
                        },
                    })(entry, vim_item)

                    -- Custom menu labels
                    local menu_map = {
                        copilot = "[Copilot]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[Snip]",
                        buffer = "[Buf]",
                        path = "[Path]",
                        cmdline = "[Cmd]",
                    }

                    vim_item.menu = menu_map[entry.source.name] or "[?]"

                    -- Special handling for semicolon-prefixed snippets
                    if entry.source.name == "luasnip" and vim_item.abbr:match("^;") then
                        vim_item.abbr = vim_item.abbr:gsub("^;", "⌘ ") -- Replace ; with a nice symbol
                    end

                    return vim_item
                end,
            }

            -- All sources in same group with Copilot prioritization via comparators
            opts.sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = "nvim_lsp", group_index = 2 },
                { name = "luasnip", group_index = 2 },
                { name = "buffer", group_index = 2, keyword_length = 3 },
                { name = "path", group_index = 2 },
            })

            -- Enhanced sorting with stronger Copilot prioritization
            opts.sorting = {
                priority_weight = 2,
                comparators = {
                    -- Custom comparator that strongly prioritizes Copilot
                    function(entry1, entry2)
                        local source1 = entry1.source.name
                        local source2 = entry2.source.name

                        if source1 == "copilot" and source2 ~= "copilot" then
                            return true
                        elseif source1 ~= "copilot" and source2 == "copilot" then
                            return false
                        end

                        -- If both or neither are copilot, continue with normal sorting
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

            -- Smart completion behavior that works with semicolon snippets
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            -- Enhanced mapping optimized for LuaSnip setup
            opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
                -- Trigger completion when typing semicolon
                [";"] = cmp.mapping(function(fallback)
                    if not cmp.visible() then
                        cmp.complete()
                    end
                    fallback()
                end, { "i" }),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<CR>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if luasnip.expandable() and cmp.get_active_entry() then
                            luasnip.expand()
                        else
                            cmp.confirm({
                                behavior = cmp.ConfirmBehavior.Replace,
                                select = false,
                            })
                        end
                    else
                        fallback()
                    end
                end),

                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<C-f>"] = cmp.mapping.scroll_docs(-4),
                ["<C-b>"] = cmp.mapping.scroll_docs(4),
            })

            -- Performance optimizations
            opts.performance = {
                debounce = 60,
                throttle = 30,
                fetching_timeout = 500,
                confirm_resolve_timeout = 80,
                async_budget = 1,
                max_view_entries = 200,
            }

            -- Completion behavior optimized for coding
            opts.completion = {
                completeopt = "menu,menuone,noinsert",
                keyword_length = 1,
            }

            -- Keep your ghost_text preference
            opts.experimental = opts.experimental or {}
            opts.experimental.ghost_text = false

            return opts
        end,
    },

    {
        "onsails/lspkind.nvim",
        lazy = true,
        opts = {
            mode = "symbol_text",
            preset = "codicons",
            symbol_map = {
                Copilot = "",
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰜢",
                Variable = "󰀫",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "󰈇",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "󰙅",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "",
            },
        },
    },
}
