-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- -- Add this to ~/.config/nvim/lua/config/keymaps.lua (if using LazyVim)
-- or add to your init.lua if you have a different setup
local map = vim.keymap.set

-- File operations
map("n", "<leader>fw", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit buffer" })

vim.api.nvim_create_user_command("W", "w", {})

local function dive_with_count_object()
    local count = vim.v.count1 -- Gets the count prefix (defaults to 1)
    local original_pos = vim.fn.getpos(".")

    -- Jump to the nth occurrence of {
    for i = 1, count do
        local found = vim.fn.search("{", "W")
        if found == 0 then
            vim.fn.setpos(".", original_pos)
            print("Only found " .. (i - 1) .. " blocks forward")
            return
        end
    end

    vim.cmd("normal! vi{")
end

local function dive_with_count_paren()
    local count = vim.v.count1
    local original_pos = vim.fn.getpos(".")

    -- Jump to the nth occurrence of (
    for i = 1, count do
        local found = vim.fn.search("(", "W")
        if found == 0 then
            vim.fn.setpos(".", original_pos)
            print("Only found " .. (i - 1) .. " parentheses forward")
            return
        end
    end

    vim.cmd("normal! vi(")
end

map("n", "vi{", dive_with_count_object, { desc = "Dive inside nth { block" })
map("n", "vi(", dive_with_count_paren, { desc = "Dive inside nth ( block" })

-- Buffer control
map("n", "<M-i>", "<cmd>vertical resize +5<cr>", { desc = "Increase buffer width" })
map("n", "<M-d>", "<cmd>vertical resize -5<cr>", { desc = "Decrease buffer width" })
map("n", "<M-I>", "<cmd>resize +5<cr>", { desc = "Increase buffer height" })
map("n", "<M-D>", "<cmd>resize -5<cr>", { desc = "Decrease buffer height" })
map("n", "<leader>\\", "<cmd>vsplit<cr>", { desc = "Split window vertically" })

-- Obsidian
map("n", "<leader>On", ":ObsidianNew<CR>", { desc = "Obsidian: New Note in Workspace" })
map("n", "<leader>Os", ":ObsidianSearch<CR>", { desc = "Obsidian: Search Notes in Workspace" })
map("n", "<leader>Ol", ":ObsidianQuickSwitch<CR>", { desc = "Obsidian: List Notes in Workspace" })
map("n", "<leader>Ot", ":ObsidianToday<CR>", { desc = "Obsidian: Notes for today" })
