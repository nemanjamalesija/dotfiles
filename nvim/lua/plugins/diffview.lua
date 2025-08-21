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
        { "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", desc = "Git Current File History" },
        { "<leader>gdo", "<Cmd>DiffviewOpen<CR>", desc = "Open Git Diff Current File" },
        { "<leader>gdc", "<Cmd>DiffviewClose<CR>", desc = "Close Git Diff Current File" },
    },
}
