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
        init = function()
            local substitute = require("substitute")

            vim.keymap.set("n", "s", substitute.operator, { noremap = true, desc = "Substitute operator" })
            vim.keymap.set("n", "S", substitute.line, { noremap = true, desc = "Substitute line" })
            vim.keymap.set("n", "ss", substitute.eol, { noremap = true, desc = "Substitute to end of line" })
            vim.keymap.set("x", "s", substitute.visual, { noremap = true, desc = "Substitute visual" })

            vim.api.nvim_set_hl(0, "SubstituteSubstituted", { link = "Substitute" })
            vim.api.nvim_set_hl(0, "SubstituteRange", { link = "Substitute" })
        end,
    },
}
