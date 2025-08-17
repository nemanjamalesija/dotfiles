vim.keymap.set("n", "<leader>nc", function()
    require("notify").dismiss()
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
                    -- render = "minimal",
                    render = "default",
                    stages = "fade",
                    level = 3,
                })
            end,
        },
    },
    opts = {
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
            },
        },
        notify = {
            enabled = true,
            view = "notify",
        },
        cmdline = {
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
        routes = {
            {
                filter = {
                    event = "msg_show",
                    find = "written",
                },
                opts = { skip = true },
            },
        },
    },
}
