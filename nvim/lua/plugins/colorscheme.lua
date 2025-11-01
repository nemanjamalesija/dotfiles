return {
    -- {
    --     "sainnhe/everforest",
    --     -- lazy = false,
    --     -- priority = 1000,
    --     config = function()
    --         -- vim.g.everforest_background = "hard"
    --         -- vim.g.everforest_enable_italic = false
    --         vim.g.everforest_better_performance = 1
    --         -- vim.cmd.colorscheme("everforest")
    --     end,
    -- },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        -- priority = 1000,
        -- lazy = false,
        config = function()
            require("catppuccin").setup({
                flavour = "macchiato",
                no_italic = true,
                transparent_background = true,
                float = {
                    enabled = true,
                    transparent = false,
                    solid = false,
                },
                lsp_styles = {
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                        ok = { "undercurl" },
                    },
                    inlay_hints = {
                        background = true,
                    },
                },
            })
        end,
    },
    {
        "Mofiqul/vscode.nvim",
        -- priority = 1000,
        config = function()
            vim.o.background = "dark"
            require("vscode").setup({
                background = "hard",
                transparent = true,
                terminal_colors = true,
            })
            -- vim.cmd.colorscheme("vscode")
        end,
    },
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        priority = 1000,
        config = function()
            require("everforest").setup({
                background = "medium",
                colours_override = function(palette)
                    palette.orange = "#4791e4"
                    palette.fg = "#666777"
                    palette.blue = "#666777"
                    palette.aqua = "#2aa198"
                    -- palette.green = "#008000"
                end,
                on_highlights = function(hl, palette)
                    hl["@punctuation.bracket"] = { fg = palette.fg }
                    local orange = "#f57d26"

                    hl["@tag"] = { fg = palette.orange, bold = true }
                    hl["@tag.bracket"] = { fg = palette.fg }
                    hl["@tag.delimiter"] = { fg = palette.fg }
                    hl["@tag.attribute"] = { fg = palette.fg, bg = palette.bg1 }
                    hl["@tag.attribute.vue"] = { fg = palette.fg, bg = palette.bg1 }

                    hl["@keyword"] = { fg = palette.red }
                    hl["@keyword.import.javascript"] = { fg = palette.red }
                    hl["@keyword.export.javascript"] = { fg = palette.red }

                    hl["@operator"] = { fg = palette.green }
                    hl["@operator.javascript"] = { fg = palette.green }

                    hl["@variable.parameter"] = { fg = orange }
                    hl["@lsp.type.parameter.vue"] = { fg = orange }
                    hl["@variable.parameter.javascript"] = { fg = orange }

                    hl.DiagnosticUnderlineHint = { fg = palette.aqua, undercurl = true, sp = palette.purple }
                    hl.DiagnosticUnderlineWarn = { fg = "NONE", undercurl = true, sp = orange }
                    hl.DiagnosticUnderlineError = { fg = "NONE", undercurl = true, sp = palette.red }
                end,

                vim.cmd.colorscheme("everforest"),
            })
        end,
    },
}
