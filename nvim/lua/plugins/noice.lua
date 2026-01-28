return {
    {
        "folke/noice.nvim",
        opts = {
            presets = {
                bottom_search = false,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = true, -- add a border to hover docs and signature help
            },
            lsp = {
                override = {
                    -- Override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                hover = {
                    enabled = true,
                    silent = false, -- set to true to not show a message if hover is not available
                    view = nil, -- when nil, use defaults from documentation
                    opts = {
                        -- Hover window options - use rounded borders to match diagnostics and completion
                        border = {
                            style = "rounded",
                        },
                        position = { row = 2, col = 2 },
                        size = {
                            max_width = 80,
                            max_height = 15,
                        },
                        win_options = {
                            winhighlight = {
                                Normal = "NormalFloat",
                                FloatBorder = "FloatBorder",
                            },
                        },
                    },
                },
                signature = {
                    enabled = true,
                    auto_open = {
                        enabled = true,
                        trigger = true,
                        luasnip = true,
                        throttle = 50,
                    },
                    view = nil,
                    opts = {
                        -- Signature help window options - use rounded borders
                        border = {
                            style = "rounded",
                        },
                        position = { row = 2, col = 2 },
                        size = {
                            max_width = 80,
                            max_height = 10,
                        },
                        win_options = {
                            winhighlight = {
                                Normal = "NormalFloat",
                                FloatBorder = "FloatBorder",
                            },
                        },
                    },
                },
            },
            views = {
                -- Configure the view for hover popups
                hover = {
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    position = { row = 2, col = 2 },
                    size = {
                        max_width = 80,
                        max_height = 15,
                    },
                    win_options = {
                        winhighlight = {
                            Normal = "NormalFloat",
                            FloatBorder = "FloatBorder",
                        },
                    },
                },
            },
            routes = {
                -- Route long messages to split
                {
                    filter = {
                        event = "msg_show",
                        min_height = 20,
                    },
                    view = "split",
                },
                -- Skip "written" messages
                {
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "written",
                    },
                    opts = { skip = true },
                },
            },
        },
    },
}
