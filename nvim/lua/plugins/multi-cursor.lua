vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        -- Link multicursor highlights to existing ones from your colorscheme
        vim.api.nvim_set_hl(0, "MultiCursorMain", { link = "Visual" })
        vim.api.nvim_set_hl(0, "MultiCursor", { link = "Visual" })
    end,
})
return {
    {
        "smoka7/multicursors.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "Cathyprime/hydra.nvim",
        },
        opts = {},
        cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
        keys = {
            {
                "<Leader>m",
                "<CMD>MCstart<CR>",
                desc = "multicursor",
            },
            {
                "<Leader>m",
                "<CMD>MCvisual<CR>",
                mode = "v",
                desc = "multicursor",
            },
            {
                "<c-j>",
                "<CMD>MCunderCursor<CR>",
                desc = "multicursor down",
            },
        },
    },
}
