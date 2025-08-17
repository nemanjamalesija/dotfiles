return {
    "smjonas/inc-rename.nvim",
    config = function()
        require("inc_rename").setup({
            cmd_name = "IncRename",
            hl_group = "Substitute",
            preview_empty_name = false,
            show_message = true,
            save_in_cmdline_history = true,
            input_buffer_type = nil,
            post_hook = nil,
        })

        -- Keymaps
        vim.keymap.set("n", "<leader>rn", ":IncRename ")
    end,
}
