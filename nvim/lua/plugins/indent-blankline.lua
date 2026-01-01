return {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    opts = function()
        vim.api.nvim_set_hl(0, "IblScope", { fg = "#bf68d9" })
        return {
            indent = {
                char = "┃",
                tab_char = "┃",
            },
            scope = {
                enabled = true,
                show_start = true,
                show_end = true,
                char = "▏",
                highlight = { "IblScope" },
                include = {
                    node_type = {
                        javascript = {
                            "object_pattern",
                            "object",
                            "array",
                            "arguments",
                            "statement_block",
                        },
                        typescript = {
                            "object_pattern",
                            "object",
                            "array",
                            "arguments",
                            "statement_block",
                        },
                    },
                },
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
