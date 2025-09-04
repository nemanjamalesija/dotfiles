return {
    {
        "folke/tokyonight.nvim",
        enabled = false,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        -- priority = 1000,
        -- lazy = false,
        config = function()
            require("catppuccin").setup({
                flavour = "macchiato",
                -- transparent_background = true,
                float = {
                    enabled = true,
                    transparent = false,
                    solid = false,
                },
            })
        end,
    },
    {
        "sainnhe/everforest",
        -- lazy = false,
        -- priority = 1000,
        config = function()
            vim.g.everforest_background = "hard"
            vim.g.everforest_enable_italic = true
            vim.g.everforest_better_performance = 1
            -- vim.cmd.colorscheme("everforest")
        end,
    },
    {
        "Mofiqul/vscode.nvim",
        config = function()
            vim.o.background = "dark"
            require("vscode").setup({
                background = "hard",
            })
            -- vim.cmd.colorscheme("vscode")
        end,
    },
    {
        "olivercederborg/poimandres.nvim",
        config = function()
            require("poimandres").setup({
                bold_vert_split = false,
                dim_nc_background = false,
                disable_background = false,
                disable_float_background = false,
                disable_italics = false,
            })
            -- vim.cmd.colorscheme("poimandres")
        end,
    },
    {
        "rose-pine/neovim",
        config = function()
            -- vim.cmd("colorscheme kanagawa-dragon")
        end,
    },
}
