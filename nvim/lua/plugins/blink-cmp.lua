return {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
        "zbirenbaum/copilot.lua",
        {
            "giuxtaposition/blink-cmp-copilot",
        },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = "mono",
        },
        sources = {
            default = { "snippets", "lsp", "path", "buffer", "copilot" },
            providers = {
                snippets = {
                    name = "snippets",
                    score_offset = 100,
                },
                copilot = {
                    name = "copilot",
                    module = "blink-cmp-copilot",
                    score_offset = 99,
                    async = true,
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
