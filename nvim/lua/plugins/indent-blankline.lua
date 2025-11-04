return {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    opts = function()
        -- Create custom highlight group for scope only
        vim.api.nvim_set_hl(0, "IblScope", { fg = "#f57D26" })

        return {
            indent = {
                char = "▏",
                tab_char = "▏",
            },
            scope = {
                enabled = true,
                show_end = false,
                show_start = true,
                char = "▏",
                highlight = { "IblScope" },
                -- highlight = { "Label" },
            },
            exclude = {
                filetypes = {
                    "Trouble",
                    "alpha",
                    "dashboard",
                    "help",
                    "lazy",
                    "mason",
                    "neo-tree",
                    "notify",
                    "snacks_dashboard",
                    "snacks_notif",
                    "snacks_terminal",
                    "snacks_win",
                    "toggleterm",
                    "trouble",
                },
            },
        }
    end,
    main = "ibl",
}
