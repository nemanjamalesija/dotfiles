-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- -- Add this to ~/.config/nvim/lua/config/keymaps.lua (if using LazyVim)
-- or add to your init.lua if you have a different setup
--

-- File operations
vim.keymap.set("n", "<leader>s", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit buffer" })

vim.keymap.set("n", "<leader>ts", function()
    if vim.o.background == "dark" then
        vim.o.background = "light"
        print("Switched to light mode")
    else
        vim.o.background = "dark"
        print("Switched to dark mode")
    end
end, { desc = "Toggle between light and dark mode" })

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

vim.keymap.set("n", "vi{", dive_with_count_object, { desc = "Dive inside nth { block" })
vim.keymap.set("n", "vi(", dive_with_count_paren, { desc = "Dive inside nth ( block" })

-- Buffer control
vim.keymap.set("n", "<M-w>", "<cmd>bdelete<cr>", { desc = "Buffer delete" })
vim.keymap.set("n", "<M-i>", "<cmd>vertical resize +5<cr>", { desc = "Increase buffer width" })
vim.keymap.set("n", "<M-d>", "<cmd>vertical resize -5<cr>", { desc = "Decrease buffer width" })
vim.keymap.set("n", "<M-I>", "<cmd>resize +5<cr>", { desc = "Increase buffer height" })
vim.keymap.set("n", "<M-D>", "<cmd>resize -5<cr>", { desc = "Decrease buffer height" })
vim.keymap.set("n", "<leader>\\", "<cmd>split<cr>", { desc = "Split window horizontally" })
-- vim.keymap.set("n", "<M-l>", "<C-w>l", { desc = "Focus split right" })
-- vim.keymap.set("n", "<M-h>", "<C-w>h", { desc = "Focus split left" })
-- vim.keymap.set("n", "<M-k>", "<C-w>k", { desc = "Focus split up" })
-- vim.keymap.set("n", "<M-j>", "<C-w>j", { desc = "Focus split down" })

-- Obsidian
vim.keymap.set("n", "<leader>On", ":ObsidianNew<CR>", { desc = "Obsidian: New Note in Workspace" })
vim.keymap.set("n", "<leader>Os", ":ObsidianSearch<CR>", { desc = "Obsidian: Search Notes in Workspace" })
vim.keymap.set("n", "<leader>Ol", ":ObsidianQuickSwitch<CR>", { desc = "Obsidian: List Notes in Workspace" })
vim.keymap.set("n", "<leader>Ot", ":ObsidianToday<CR>", { desc = "Obsidian: Notes for today" })
