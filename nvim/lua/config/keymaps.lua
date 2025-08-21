-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- -- Add this to ~/.config/nvim/lua/config/keymaps.lua (if using LazyVim)
-- or add to your init.lua if you have a different setup
--

-- File operations
vim.keymap.set("n", "<leader>s", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit buffer" })

vim.keymap.set("n", "<leader>S", ":%s/", { noremap = true, desc = "Substitute word" })

vim.keymap.set("n", "<leader>r", [["_ddP]], { desc = "Replace current line with yanked text" })

vim.keymap.set("n", "<leader>ts", function()
    if vim.o.background == "dark" then
        vim.o.background = "light"
        print("Switched to light mode")
    else
        vim.o.background = "dark"
        print("Switched to dark mode")
    end
end, { desc = "Toggle between light and dark mode" })

vim.keymap.set("n", "<leader>my", function()
    -- Enter insert mode and trigger completion
    vim.cmd("startinsert")
    vim.schedule(function()
        require("cmp").complete()
    end)
end)

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
