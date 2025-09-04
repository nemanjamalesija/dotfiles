vim.keymap.set("n", "<leader>nc", function()
    require("notify").dismiss({ silent = true, pending = false })
end, { desc = "Dismiss notify popup and clear hlsearch" })

return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        {
            "rcarriga/nvim-notify",
            config = function()
                require("notify").setup({
                    timeout = 3000,
                    max_height = function()
                        return math.floor(vim.o.lines * 0.75)
                    end,
                    max_width = function()
                        return math.floor(vim.o.columns * 0.60)
                    end,
                    on_open = function(win)
                        vim.api.nvim_win_set_config(win, { focusable = true })
                    end,
                    render = "default",
                    stages = "fade",
                    level = vim.log.levels.WARN,
                    merge_duplicates = false,
                })
            end,
        },
    },
    opts = {
        cmdline = {
            enabled = true,
            view = "cmdline",
            format = {
                search_down = { view = "cmdline" },
                search_up = { view = "cmdline" },
            },
        },
    },
}
