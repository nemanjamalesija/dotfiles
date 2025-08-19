return {
    "sindrets/diffview.nvim",
    cmd = {
        "DiffviewOpen",
        "DiffviewFileHistory",
        "DiffviewFocusFiles",
        "DiffviewToggleFiles",
        "DiffviewRefresh",
        "DiffviewLog",
    },
    keys = {
        { "<leader>gf", "<Cmd>DiffviewFileHistory %<CR>", desc = "Git Current File History" },
        { "<leader>go", "<Cmd>DiffviewOpen<CR>", desc = "Open Git Diff Current File" },
        { "<leader>gc", "<Cmd>DiffviewClose<CR>", desc = "Close Git Diff Current File" },
    },
}
