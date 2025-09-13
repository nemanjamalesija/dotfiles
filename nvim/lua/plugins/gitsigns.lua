local M = {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
}

M.config = function()
    require("gitsigns").setup({
        word_diff = false,
        attach_to_untracked = true,
        on_attach = function()
            local gs = package.loaded.gitsigns
            -- Navigation
            vim.keymap.set({ "n", "v" }, "]h", function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return "<Ignore>"
            end, { expr = true, desc = "Next hunk" })
            vim.keymap.set({ "n", "v" }, "[h", function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return "<Ignore>"
            end, { expr = true, desc = "Previous hunk" })

            -- Actions
            vim.keymap.set("n", "<leader>gA", gs.stage_buffer, { desc = "Stage buffer" })
            vim.keymap.set("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
            vim.keymap.set({ "n", "v" }, "<leader>ga", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
            vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
            vim.keymap.set({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
            vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
            vim.keymap.set("n", "<leader>gb", function()
                gs.blame_line({ full = true })
            end, { desc = "Blame line" })
            vim.keymap.set("n", "<leader>gtd", gs.toggle_deleted, { desc = "Toggle deleted" })
            vim.keymap.set("n", "<leader>gtw", gs.toggle_word_diff, { desc = "Toggle word diff" })
            -- Text object
            vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Hunk" })
        end,
    })
end

return M
