return {
    {
        "sainnhe/everforest",
        -- lazy = false,
        -- priority = 1000,
        config = function()
            vim.g.everforest_background = "hard"
            vim.g.everforest_enable_italic = false
            vim.g.everforest_better_performance = 1
            -- vim.cmd.colorscheme("everforest")
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
        "Mofiqul/vscode.nvim",
        config = function()
            vim.o.background = "dark"
            require("vscode").setup({
                background = "hard",
            })
            -- vim.cmd.colorscheme("vscode")
        end,
    },
}
