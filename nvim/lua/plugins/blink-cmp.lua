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
        sources = {
            default = { "lsp", "path", "snippets", "buffer", "copilot" },
            providers = {
                copilot = {
                    name = "copilot",
                    module = "blink-cmp-copilot",
                    score_offset = 100,
                    async = true,
                },
            },
        },
        completion = {
            ghost_text = {
                enabled = false,
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
        },
    },
}
