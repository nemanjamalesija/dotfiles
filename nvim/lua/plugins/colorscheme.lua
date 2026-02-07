return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
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
            -- Load catppuccin if dark theme
            if vim.g.theme_mode == "dark" then
                vim.cmd.colorscheme("catppuccin")
            end
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
                    palette.fg = "#586e75"
                    palette.blue = "#586e75"
                    palette.aqua = "#2aa198"
                end,
                on_highlights = function(hl, palette)
                    local solarizedYellow = "#b58900"
                    local customOrange = "#e47112"

                    hl["@punctuation.bracket"] = { fg = palette.fg }

                    -- HTML tags
                    hl["@tag"] = { fg = palette.orange, bold = false }
                    hl["@tag.bracket"] = { fg = palette.fg }
                    hl["@tag.delimiter"] = { fg = palette.fg }
                    hl["@tag.attribute"] = { fg = palette.fg, bg = palette.bg1 }

                    hl["@keyword"] = { fg = solarizedYellow, bold = false }
                    hl["@keyword.import"] = { fg = solarizedYellow, bold = false }
                    hl["@keyword.export"] = { fg = solarizedYellow, bold = false }
                    hl["@keyword.import.javascript"] = { fg = solarizedYellow, bold = false }
                    hl["@keyword.export.javascript"] = { fg = solarizedYellow, bold = false }
                    hl["@keyword.return"] = { fg = solarizedYellow, bold = false }
                    hl["@keyword.operator"] = { fg = solarizedYellow, bold = false }
                    hl["@keyword.repeat"] = { fg = solarizedYellow, bold = false }
                    hl["@keyword.exception"] = { fg = solarizedYellow, bold = false }
                    hl["@keyword.modifier"] = { fg = solarizedYellow, bold = false }
                    hl["@keyword.type"] = { fg = solarizedYellow, bold = false }
                    hl["@keyword.coroutine"] = { fg = solarizedYellow, bold = false }
                    hl["@keyword.directive"] = { fg = solarizedYellow, bold = false }
                    hl["@keyword.function"] = { fg = solarizedYellow, bold = false }

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

                    hl["@variable.parameter"] = { fg = customOrange }
                    hl["@lsp.type.parameter.vue"] = { fg = customOrange }
                    hl["@lsp.type.parameter.javascript"] = { fg = customOrange }
                    hl["@variable.parameter.javascript"] = { fg = customOrange }

                    hl.DiagnosticUnderlineHint = { fg = palette.aqua, undercurl = true, sp = palette.purple }
                    hl.DiagnosticUnderlineWarn = { fg = "NONE", undercurl = true, sp = customOrange }
                    hl.DiagnosticUnderlineError = { fg = "NONE", undercurl = true, sp = palette.red }
                end,
            })
            -- Load everforest if light theme
            if vim.g.theme_mode == "light" then
                vim.o.background = "light"
                vim.cmd.colorscheme("everforest")
            end
        end,
    },
    {
        "Mofiqul/vscode.nvim",
        config = function()
            require("vscode").setup({
                background = "hard",
                transparent = true,
                terminal_colors = true,
            })
            -- vim.cmd.colorscheme("vscode")
        end,
    },
}
