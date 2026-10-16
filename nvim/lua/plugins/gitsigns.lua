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

            local function get_unstaged_line_count()
                local count = 0
                for _, hunk in ipairs(gs.get_hunks() or {}) do
                    count = count + hunk.added.count + hunk.removed.count
                end
                return count
            end

            -- stage_hunk stages or unstages depending on the lines, and the sign
            -- only turns paler, so we say which one happened.
            local function stage_or_unstage_hunk(range)
                local unstaged_before = get_unstaged_line_count()
                gs.stage_hunk(range, nil, function()
                    local unstaged_after = get_unstaged_line_count()
                    if unstaged_after < unstaged_before then
                        vim.notify("Staged hunk")
                    elseif unstaged_after > unstaged_before then
                        vim.notify("Unstaged hunk")
                    end
                end)
            end

            -- Navigation
            vim.keymap.set({ "n", "v" }, "]h", function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    gs.nav_hunk("next", { target = "all" })
                end)
                return "<Ignore>"
            end, { expr = true, desc = "Next hunk" })
            vim.keymap.set({ "n", "v" }, "[h", function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    gs.nav_hunk("prev", { target = "all" })
                end)
                return "<Ignore>"
            end, { expr = true, desc = "Previous hunk" })

            -- Actions
            vim.keymap.set("n", "<leader>gA", gs.stage_buffer, { desc = "Stage buffer" })
            vim.keymap.set("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
            vim.keymap.set("n", "<leader>ga", function()
                stage_or_unstage_hunk()
            end, { desc = "Stage or unstage hunk" })
            vim.keymap.set("v", "<leader>ga", function()
                local range = { vim.fn.line("."), vim.fn.line("v") }
                vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
                stage_or_unstage_hunk(range)
            end, { desc = "Stage or unstage lines" })
            vim.keymap.set("n", "<leader>gr", function()
                gs.reset_hunk()
            end, { desc = "Reset hunk" })
            vim.keymap.set("v", "<leader>gr", function()
                local range = { vim.fn.line("."), vim.fn.line("v") }
                vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
                gs.reset_hunk(range)
            end, { desc = "Reset lines" })
            vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
            vim.keymap.set("n", "<leader>gi", gs.preview_hunk_inline, { desc = "Preview hunk inline" })
            vim.keymap.set("n", "<leader>gb", function()
                gs.blame_line({ full = true })
            end, { desc = "Blame line" })
            vim.keymap.set("n", "<leader>gm", function()
                gs.show("master:%", { open = "vsplit" }, function()
                    vim.wo.winbar = " master"
                end)
            end, { desc = "Show file on master" })
            vim.keymap.set("n", "<leader>gta", gs.toggle_linehl, { desc = "Toggle added/changed line highlight" })

            -- Text object
            vim.keymap.set({ "o", "x" }, "ih", gs.select_hunk, { desc = "Hunk" })
        end,
    })
end

return M
