vim.keymap.set("n", "<leader>nc", function()
    require("notify").dismiss({ silent = true, pending = false })
end, { desc = "Dismiss notify popup and clear hlsearch" })

return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
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
                    -- Remove or lower the level to show more message types
                    level = vim.log.levels.INFO, -- Changed from 3 to INFO
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
        views = {
            notify = {
                backend = "notify",
                fallback = "mini",
                format = "notify",
                replace = false,
                merge = false,
                win_options = {
                    winblend = 0,
                    wrap = true,
                },
                position = {
                    row = 1,
                    col = -2,
                },
            },
        },
    },
}
