return {
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            require("onedark").setup({
                style = "darker",
                -- transparent = true,
            })
            -- require("onedark").load()
        end,
    },
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
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        priority = 1000,
        config = function()
            require("everforest").setup({
                background = "medium",
                colours_override = function(palette)
                    -- palette.fg = "#707181"
                    -- palette.blue = "#707181"
                    palette.orange = "#4791e4"
                    palette.fg = "#586e75"
                    palette.blue = "#586e75"
                    palette.aqua = "#2aa198"
                    -- palette.green = "#719e07"
                    -- palette.green = "#859900"
                end,
                on_highlights = function(hl, palette)
                    local solarizedYellow = "#b58900"
                    local customOrange = "#e47112"
                    -- #f57D26

                    hl["@punctuation.bracket"] = { fg = palette.fg }

                    -- HTML tags
                    hl["@tag"] = { fg = palette.orange, bold = true }
                    hl["@tag.bracket"] = { fg = palette.fg }
                    hl["@tag.delimiter"] = { fg = palette.fg }
                    hl["@tag.attribute"] = { fg = palette.fg, bg = palette.bg1 }
                    -- hl["@tag.attribute.vue"] = { fg = palette.fg, bg = palette.bg1 }

                    -- Keywords

                    hl["@keyword"] = { fg = solarizedYellow, bold = true }
                    hl["@keyword.import"] = { fg = solarizedYellow, bold = true }
                    hl["@keyword.export"] = { fg = solarizedYellow, bold = true }
                    hl["@keyword.import.javascript"] = { fg = solarizedYellow, bold = true }
                    hl["@keyword.export.javascript"] = { fg = solarizedYellow, bold = true }
                    hl["@keyword.return"] = { fg = solarizedYellow, bold = true }
                    hl["@keyword.operator"] = { fg = solarizedYellow, bold = true }
                    hl["@keyword.repeat"] = { fg = solarizedYellow, bold = true }
                    hl["@keyword.exception"] = { fg = solarizedYellow, bold = true }
                    hl["@keyword.modifier"] = { fg = solarizedYellow, bold = true }
                    hl["@keyword.type"] = { fg = solarizedYellow, bold = true }
                    hl["@keyword.coroutine"] = { fg = solarizedYellow, bold = true }
                    hl["@keyword.directive"] = { fg = solarizedYellow, bold = true }
                    hl["@keyword.function"] = { fg = solarizedYellow, bold = true }

                    -- hl["@function"] = { fg = palette.green, bold = true }
                    -- hl["@function.method"] = { fg = palette.green, bold = true }

                    -- Operators
                    hl["@operator"] = { fg = solarizedYellow }
                    hl["@operator.logical"] = { fg = solarizedYellow }
                    hl["@operator.comparison"] = { fg = solarizedYellow }
                    hl["@operator.arithmetic"] = { fg = solarizedYellow }
                    hl["@operator.bitwise"] = { fg = solarizedYellow }
                    hl["@operator.assignment"] = { fg = solarizedYellow }
                    hl["@operator.ternary"] = { fg = solarizedYellow }
                    hl["@operator.spread"] = { fg = solarizedYellow }
                    hl["@operator.pipeline"] = { fg = solarizedYellow }
                    hl["@keyword.conditional"] = { fg = solarizedYellow }

                    -- Parameters
                    hl["@variable.parameter"] = { fg = customOrange }
                    hl["@lsp.type.parameter.vue"] = { fg = customOrange }
                    hl["@lsp.type.parameter.javascript"] = { fg = customOrange }
                    hl["@variable.parameter.javascript"] = { fg = customOrange }

                    hl.DiagnosticUnderlineHint = { fg = palette.aqua, undercurl = true, sp = palette.purple }
                    hl.DiagnosticUnderlineWarn = { fg = "NONE", undercurl = true, sp = customOrange }
                    hl.DiagnosticUnderlineError = { fg = "NONE", undercurl = true, sp = palette.red }
                end,

                vim.cmd.colorscheme("everforest"),
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
                -- transparent = true,
                terminal_colors = true,
            })
            -- vim.cmd.colorscheme("vscode")
        end,
    },
}
