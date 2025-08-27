return {
    {
        "gelguy/wilder.nvim",
        keys = {
            ":",
            "/",
            "?",
        },
        dependencies = {
            "catppuccin/nvim",
        },
        config = function()
            local wilder = require("wilder")

            local function get_current_palette()
                if vim.o.background == "dark" then
                    return require("catppuccin.palettes").get_palette("macchiato")
                else
                    return require("catppuccin.palettes").get_palette("latte")
                end
            end

            local function create_highlights()
                local palette = get_current_palette()
                local text_highlight =
                    wilder.make_hl("WilderText", { { a = 1 }, { a = 1 }, { foreground = palette.text } })
                local mauve_highlight =
                    wilder.make_hl("WilderMauve", { { a = 1 }, { a = 1 }, { foreground = palette.mauve } })
                return text_highlight, mauve_highlight
            end

            -- Function to setup renderer with current colors
            local function setup_renderer()
                local text_highlight, mauve_highlight = create_highlights()

                wilder.set_option(
                    "renderer",
                    wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
                        highlighter = wilder.basic_highlighter(),
                        highlights = {
                            default = text_highlight,
                            border = mauve_highlight,
                            accent = mauve_highlight,
                        },
                        pumblend = 5,
                        min_width = "100%",
                        min_height = "25%",
                        max_height = "25%",
                        border = "rounded",
                        left = { " ", wilder.popupmenu_devicons() },
                        right = { " ", wilder.popupmenu_scrollbar() },
                    }))
                )
            end

            -- Enable wilder when pressing :, / or ?
            wilder.setup({ modes = { ":", "/", "?" } })

            -- Enable fuzzy matching for commands and buffers
            wilder.set_option("pipeline", {
                wilder.branch(
                    wilder.cmdline_pipeline({
                        fuzzy = 1,
                    }),
                    wilder.vim_search_pipeline({
                        fuzzy = 1,
                    })
                ),
            })

            -- Initial setup
            setup_renderer()

            -- Auto-update colors when colorscheme changes
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "*",
                callback = function()
                    -- Small delay to ensure the colorscheme is fully loaded
                    vim.defer_fn(setup_renderer, 100)
                end,
            })

            -- Auto-update colors when background changes
            vim.api.nvim_create_autocmd("OptionSet", {
                pattern = "background",
                callback = function()
                    setup_renderer()
                end,
            })
        end,
    },
}
