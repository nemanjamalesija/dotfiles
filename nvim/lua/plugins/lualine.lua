local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
        }
    end
end

return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function(_, opts)
        opts.options = {
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            globalstatus = true,
        }
        opts.sections = {
            lualine_a = { "mode" },
            lualine_b = {
                {
                    "filename",
                    file_status = true,
                    path = 1,
                    symbols = {
                        modified = "[+]",
                        readonly = "[]",
                        unnamed = "[No Name]",
                        newfile = "[New]",
                    },
                    shorting_target = 20, -- Not relevant when path=0, but harmless
                },
                -- { "branch", icon = "" },
            },
            lualine_c = {
                {
                    "diff",
                    source = diff_source,
                },
            },
            lualine_x = {

                {
                    "diagnostics",

                    -- Table of diagnostic sources, available sources are:
                    --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
                    -- or a function that returns a table as such:
                    --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
                    sources = { "nvim_diagnostic", "coc" },

                    -- Displays diagnostics for the defined severity types
                    sections = { "error", "warn", "info", "hint" },

                    diagnostics_color = {
                        -- Same values as the general color option can be used here.
                        error = "DiagnosticError", -- Changes diagnostics' error color.
                        warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
                        info = "DiagnosticInfo", -- Changes diagnostics' info color.
                        hint = "DiagnosticHint", -- Changes diagnostics' hint color.
                    },
                    symbols = { error = "E", warn = "W", info = "I", hint = "H" },
                    colored = true, -- Displays diagnostics status in color if set to true.
                    update_in_insert = false, -- Update diagnostics in insert mode.
                    always_visible = false, -- Show diagnostics even if there are none.
                },
            },
            lualine_y = { "progress" },
            lualine_z = {
                function()
                    return os.date("%H:%M")
                end,
            },
        }
        opts.inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        }
        -- Add navic to lualine_c if desired
        if not vim.g.trouble_lualine then
            table.insert(opts.sections.lualine_c, { "navic", color_correction = "dynamic" })
        end
    end,
}
