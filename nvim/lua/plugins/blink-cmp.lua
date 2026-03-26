return {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {},
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = "mono",
        },
        sources = {
            default = { "lsp", "snippets", "path", "buffer" },
            providers = {
                lsp = {
                    name = "lsp",
                    score_offset = 100,
                },
                snippets = {
                    name = "snippets",
                    score_offset = 0,
                    transform_items = function(_, items)
                        local cursor = vim.api.nvim_win_get_cursor(0)
                        local line = vim.api.nvim_get_current_line()
                        local before_cursor = line:sub(1, cursor[2])
                        local keyword = before_cursor:match(";(%w*)$")
                        if keyword then
                            local semi_col = cursor[2] - #keyword - 1
                            local lsp_line = cursor[1] - 1
                            for _, item in ipairs(items) do
                                item.score_offset = (item.score_offset or 0) + 200
                                item.additionalTextEdits = {
                                    {
                                        newText = "",
                                        range = {
                                            start = { line = lsp_line, character = semi_col },
                                            ["end"] = { line = lsp_line, character = semi_col + 1 },
                                        },
                                    },
                                }
                            end
                        end
                        return items
                    end,
                },
            },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        completion = {
            ghost_text = {
                enabled = false,
            },
            menu = {
                auto_show = true,
                max_height = 15,
                border = "rounded",
                winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
                window = {
                    max_width = 60,
                    max_height = 13,
                    border = "rounded",
                    winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
                },
            },
        },
        keymap = {
            preset = "default",
            ["<C-e>"] = { "hide" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-f>"] = { "scroll_documentation_up", "fallback" },
            ["<C-v>"] = { "scroll_documentation_down", "fallback" },
            ["<C-l>"] = { "snippet_forward", "fallback" },
            ["<C-h>"] = { "snippet_backward", "fallback" },
            ["<M-Space>"] = { "show", "fallback" },
        },
    },
}
