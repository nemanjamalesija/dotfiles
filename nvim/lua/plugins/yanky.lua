return {
    "gbprod/yanky.nvim",
    opts = {
        highlight = {
            timer = 150,
        },
    },
    dependencies = { "folke/snacks.nvim" },
    keys = {
        {
            "<leader>yh",
            function()
                Snacks.picker.yanky()
            end,
            mode = { "n", "x" },
            desc = "Open Yank History",
        },
        {
            "p",
            "<Plug>(YankyPutAfter)",
            mode = { "n", "x" },
            desc = "Yanky Put After",
        },
        {
            "P",
            "<Plug>(YankyPutBefore)",
            mode = { "n", "x" },
            desc = "Yanky Put Before",
        },
        {
            "]p",
            "<Plug>(YankyPutIndentAfterLinewise)",
            mode = "n",
            desc = "Put below (linewise, indent)",
        },
        {
            "[p",
            "<Plug>(YankyPutIndentBeforeLinewise)",
            mode = "n",
            desc = "Put above (linewise, indent)",
        },
        {
            ">p",
            "<Plug>(YankyPutIndentAfterShiftRight)",
            mode = "n",
            desc = "Put below and shift right",
        },
        {
            "<p",
            "<Plug>(YankyPutIndentAfterShiftLeft)",
            mode = "n",
            desc = "Put below and shift left",
        },
        {
            ">P",
            "<Plug>(YankyPutIndentBeforeShiftRight)",
            mode = "n",
            desc = "Put above and shift right",
        },
        {
            "<P",
            "<Plug>(YankyPutIndentBeforeShiftLeft)",
            mode = "n",
            desc = "Put above and shift left",
        },
        {
            "<leader>yc",
            ":YankyClearHistory<CR>",
            mode = "n",
            desc = "Clear Yanky Yank History",
        },
    },
}
