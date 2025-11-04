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
                    palette.fg = "#707181"
                    palette.blue = "#707181"
                    palette.aqua = "#2aa198"
                    -- palette.green = "#6da101"
                end,
                on_highlights = function(hl, palette)
                    hl["@punctuation.bracket"] = { fg = palette.fg }
                    local customOrange = "#e47112"
                    -- #f57D26
                    -- local yellow2 = "#859900"

                    -- HTML tags
                    hl["@tag"] = { fg = palette.orange, bold = true }
                    hl["@tag.bracket"] = { fg = palette.fg }
                    hl["@tag.delimiter"] = { fg = palette.fg }
                    hl["@tag.attribute"] = { fg = palette.fg, bg = palette.bg1 }
                    -- hl["@tag.attribute.vue"] = { fg = palette.fg, bg = palette.bg1 }

                    -- Keywords

                    hl["@keyword"] = { fg = palette.red, bold = true }
                    hl["@keyword.import"] = { fg = palette.red, bold = true }
                    hl["@keyword.export"] = { fg = palette.red, bold = true }
                    hl["@keyword.import.javascript"] = { fg = palette.red, bold = true }
                    hl["@keyword.export.javascript"] = { fg = palette.red, bold = true }
                    hl["@keyword.return"] = { fg = palette.red, bold = true }
                    hl["@keyword.operator"] = { fg = palette.red, bold = true }
                    hl["@keyword.conditional"] = { fg = palette.red, bold = true }
                    hl["@keyword.repeat"] = { fg = palette.red, bold = true }
                    hl["@keyword.exception"] = { fg = palette.red, bold = true }
                    hl["@keyword.modifier"] = { fg = palette.red, bold = true }
                    hl["@keyword.type"] = { fg = palette.red, bold = true }
                    hl["@keyword.coroutine"] = { fg = palette.red, bold = true }
                    hl["@keyword.directive"] = { fg = palette.red, bold = true }
                    hl["@keyword.function"] = { fg = palette.red, bold = true }

                    hl["@function"] = { fg = palette.green, bold = true }
                    hl["@function.method"] = { fg = palette.green, bold = true }

                    -- Operators
                    hl["@operator"] = { fg = palette.red }
                    hl["@operator.logical"] = { fg = palette.red }
                    hl["@operator.comparison"] = { fg = palette.red }
                    hl["@operator.arithmetic"] = { fg = palette.red }
                    hl["@operator.bitwise"] = { fg = palette.red }
                    hl["@operator.assignment"] = { fg = palette.red }
                    hl["@operator.ternary"] = { fg = palette.red }
                    hl["@operator.spread"] = { fg = palette.red }
                    hl["@operator.pipeline"] = { fg = palette.red }

                    -- Parameters
                    hl["@variable.parameter"] = { fg = customOrange }
                    hl["@lsp.type.parameter.vue"] = { fg = customOrange }
                    hl["@variable.parameter.javascript"] = { fg = customOrange }

                    hl.DiagnosticUnderlineHint = { fg = palette.aqua, undercurl = true, sp = palette.purple }
                    hl.DiagnosticUnderlineWarn = { fg = "NONE", undercurl = true, sp = customOrange }
                    hl.DiagnosticUnderlineError = { fg = "NONE", undercurl = true, sp = palette.red }
                end,

                vim.cmd.colorscheme("everforest"),
            })
        end,
    },
}
