return {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets", "giuxtaposition/blink-cmp-copilot" },
    version = "1.*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "default",
            ["<C-e>"] = { "hide" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-f>"] = { "scroll_documentation_up", "fallback" },
            ["<C-v>"] = { "scroll_documentation_down", "fallback" },
        },
        appearance = {
            nerd_font_variant = "mono",
        },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 100,
            },
            menu = {
                draw = {
                    columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
                },
            },
            trigger = {
                show_on_insert_on_trigger_character = true,
                show_on_insert_after_debounce_ms = 200,
            },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer", "copilot" },
            min_keyword_length = 3,
            providers = {
                copilot = {
                    name = "copilot",
                    module = "blink-cmp-copilot",
                    score_offset = 100,
                    async = true,
                },
                lsp = {
                    async = true,
                    score_offset = 90,
                },
                snippets = {
                    score_offset = 80,
                },
                path = {
                    score_offset = 30,
                },
                buffer = {
                    score_offset = 10,
                },
            },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
}
