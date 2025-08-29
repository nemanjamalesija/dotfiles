return {
    {
        "anuvyklack/windows.nvim",
        dependencies = {
            "anuvyklack/middleclass",
        },
        config = function()
            vim.o.winwidth = 10
            vim.o.winminwidth = 10
            vim.o.equalalways = true
            require("windows").setup({
                autowidth = { enable = false },
            })

            vim.keymap.set("n", "<M-m>", "<Cmd>WindowsMaximize<CR>", { desc = "Maximize Window Fully" })
        end,
    },
}
