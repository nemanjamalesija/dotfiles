return {
    "easymotion/vim-easymotion",
    init = function()
        vim.api.nvim_set_keymap("n", "<leader>w", "<Plug>(easymotion-prefix)", {})
        vim.api.nvim_set_keymap("x", "<leader>w", "<Plug>(easymotion-prefix)", {})
        vim.api.nvim_set_keymap("o", "<leader>w", "<Plug>(easymotion-prefix)", {})
    end,
}
