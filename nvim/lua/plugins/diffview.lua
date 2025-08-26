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
        { "<leader>dh", "<Cmd>DiffviewFileHistory %<CR>", desc = "Git Current File History" },
        { "<leader>do", "<Cmd>DiffviewOpen<CR>", desc = "Open Git Diff Current File" },
        { "<leader>dc", "<Cmd>DiffviewClose<CR>", desc = "Close Git Diff Current File" },
    },
}
