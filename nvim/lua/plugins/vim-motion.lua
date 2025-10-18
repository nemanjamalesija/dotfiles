return {
    "easymotion/vim-easymotion",
    keys = {
        { "<leader>w", "<Plug>(easymotion-prefix)", mode = { "n", "x", "o" }, desc = "EasyMotion" },
        { "<leader>e", "<Plug>(easymotion-prefix)", mode = { "n", "x", "o" }, desc = "EasyMotion" },
        { "<leader>b", "<Plug>(easymotion-prefix)", mode = { "n", "x", "o" }, desc = "EasyMotion" },
        { "<leader>k", "<Plug>(easymotion-prefix)", mode = { "n", "x", "o" }, desc = "EasyMotion" },
        { "<leader>j", "<Plug>(easymotion-prefix)", mode = { "n", "x", "o" }, desc = "EasyMotion" },
    },
    init = function()
        pcall(function()
            vim.keymap.del("n", "<leader>e")
            vim.keymap.del("n", "<leader>b")
            vim.keymap.del("x", "<leader>e")
            vim.keymap.del("o", "<leader>e")
        end)
    end,
}
