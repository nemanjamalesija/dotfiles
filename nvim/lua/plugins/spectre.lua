return {
    {
        "nvim-pack/nvim-spectre",
        lazy = true,
        cmd = { "Spectre" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "catppuccin/nvim",
        },
        keys = {
            -- Global search and replace
            {
                "<leader>S",
                function()
                    require("spectre").toggle()
                end,
                desc = "Toggle Spectre",
            },

            -- Search current word globally
            {
                "<leader>sw",
                function()
                    require("spectre").open_visual({ select_word = true })
                end,
                desc = "Search current word",
            },

            -- Search current file only
            {
                "<leader>sf",
                function()
                    require("spectre").open_file_search({
                        select_word = true,
                        is_regex = false, -- Start with literal search
                    })
                end,
                desc = "Search in current file",
            },

            -- Search current file with current word
            {
                "<leader>sF",
                function()
                    require("spectre").open_file_search({
                        select_word = true,
                        is_regex = false,
                    })
                end,
                desc = "Search current word in file",
            },

            -- Visual mode search
            {
                "<leader>sw",
                function()
                    require("spectre").open_visual()
                end,
                mode = "v",
                desc = "Search current selection",
            },
        },
        config = function()
            local theme = require("catppuccin.palettes").get_palette("macchiato")
            vim.api.nvim_set_hl(0, "SpectreSearch", { bg = theme.red, fg = theme.base })
            vim.api.nvim_set_hl(0, "SpectreReplace", { bg = theme.green, fg = theme.base })
        end,
    },
}
