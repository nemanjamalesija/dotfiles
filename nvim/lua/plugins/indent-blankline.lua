return {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    opts = function()
        return {
            indent = {
                char = "▏",
                tab_char = "▏",
            },
            scope = {
                enabled = true,
                show_end = false,
                highlight = { "Label" },
                show_start = true,
                char = "▏",
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
