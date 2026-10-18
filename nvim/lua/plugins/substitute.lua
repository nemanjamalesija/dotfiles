return {
    {
        "gbprod/substitute.nvim",
        opts = {
            highlight_substituted_text = {
                timer = 200,
            },
            range = {
                group_substituted_text = false,
                prefix = "s",
                prompt_current_text = false,
                suffix = "",
            },
        },
        keys = {
            {
                "s",
                function()
                    require("substitute").operator()
                end,
                desc = "Substitute operator",
            },
            {
                "S",
                function()
                    require("substitute").line()
                end,
                desc = "Substitute line",
            },
            {
                "ss",
                function()
                    require("substitute").eol()
                end,
                desc = "Substitute to end of line",
            },
            {
                "s",
                function()
                    require("substitute").visual()
                end,
                mode = "x",
                desc = "Substitute visual",
            },
        },
        init = function()
            vim.api.nvim_set_hl(0, "SubstituteSubstituted", { link = "Substitute" })
            vim.api.nvim_set_hl(0, "SubstituteRange", { link = "Substitute" })
        end,
    },
}
