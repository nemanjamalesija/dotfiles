return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            explorer = { enabled = false },
            debug = { enabled = false },
            notify = { enabled = false },
            notifier = { enabled = false },
            indent = { enabled = false },
            image = {
                enabled = true,
            },
        },
        keys = {
            { "<leader>fe", false },
            { "<leader>fE", false },
        },
    },
    { "folke/persistence.nvim", enabled = false },
    { "akinsho/bufferline.nvim", enabled = false },
    { "windwp/nvim-ts-autotag", enabled = false },
    { "nvim-mini/mini.pairs", enabled = false },
    {
        "echasnovski/mini.animate",
        opts = {
            cursor = { enable = false },
        },
    },
    { "nvim-mini/mini.icons", enabled = false },
    { "nvim-mini/mini.bufremove", version = false },
    { "nvim-mini/mini.surround", enabled = false },
    { "nvim-mini/mini.splitjoin", enabled = false },
    { "nvim-mini/mini.operators", enabled = false },
    { "nvim-mini/mini.align", enabled = false },
    { "nvim-mini/mini.diff", enabled = false },
    { "zbirenbaum/copilot.lua", enabled = false },
    { "giuxtaposition/blink-cmp-copilot", enabled = false },
}
