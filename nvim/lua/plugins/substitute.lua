return {
    {
        "gbprod/substitute.nvim",
        opts = {
            highlight_substituted_text = {
                timer = 200,
            },
            range = {
                group_substituted_text = false,
                prefix = "r",
                prompt_current_text = false,
                suffix = "",
            },
        },
        init = function()
            local substitute = require("substitute")

            vim.keymap.set("n", "<leader>r", substitute.operator, { noremap = true, desc = "Substitute operator" })
            vim.keymap.set("n", "<leader>rr", substitute.line, { noremap = true, desc = "Substitute line" })
            vim.keymap.set("n", "<leader>R", substitute.eol, { noremap = true, desc = "Substitute to end of line" })
            vim.keymap.set("x", "<leader>r", substitute.visual, { noremap = true, desc = "Substitute visual" })

            vim.api.nvim_set_hl(0, "SubstituteSubstituted", { link = "Substitute" })
            vim.api.nvim_set_hl(0, "SubstituteRange", { link = "Substitute" })
        end,
    },
}
