-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- -- Add this to ~/.config/nvim/lua/config/keymaps.lua (if using LazyVim)
-- or add to your init.lua if you have a different setup
local map = vim.keymap.set

-- File operations. Saving is silent so the file name and byte count stop
-- being announced on every write. A write that actually fails still reports
-- itself, since plain silent only hides ordinary messages.
map("n", "<leader>fw", "<cmd>silent w<cr>", { desc = "Save File" })

-- LazyVim maps this to a loud write.
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>silent w<cr><esc>", { desc = "Save File" })

-- Close current buffer
map("n", "<leader>qb", "<cmd>bdelete<cr>", { desc = "Quit Buffer" })

vim.api.nvim_create_user_command("W", "silent w", {})

-- Copy the open file's path, relative to the project folder, to the clipboard.
vim.api.nvim_create_user_command("CopyPath", function()
    local path = vim.fn.expand("%:.")
    vim.fn.setreg("+", path)
    vim.notify("Copied " .. path)
end, { desc = "Copy file path" })
map("n", "<C-y>", "<cmd>CopyPath<cr>", { desc = "Copy file path" })

local function rive_with_count_object()
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

-- map("n", "vi{", dive_with_count_object, { desc = "Dive inside nth { block" })
-- map("n", "vi(", dive_with_count_paren, { desc = "Dive inside nth ( block" })

-- Buffer control
map("n", "<M-i>", "<cmd>vertical resize +5<cr>", { desc = "Increase buffer width" })
map("n", "<M-d>", "<cmd>vertical resize -5<cr>", { desc = "Decrease buffer width" })
map("n", "<M-I>", "<cmd>resize +5<cr>", { desc = "Increase buffer height" })
map("n", "<M-D>", "<cmd>resize -5<cr>", { desc = "Decrease buffer height" })
map("n", "<leader>\\", "<cmd>vsplit<cr>", { desc = "Split window vertically" })

-- Straight-line scroll: temporarily enable virtualedit during C-d/C-u.
-- When a hover float is open, the keys scroll the float instead.
local function straight_scroll(key, hover_lines)
    return function()
        local scrolled_hover = require("noice.lsp").scroll(hover_lines)
        if scrolled_hover then
            return
        end
        local col = vim.fn.virtcol(".")
        vim.opt.virtualedit = "all"
        local escaped = vim.api.nvim_replace_termcodes(key, true, false, true)
        vim.api.nvim_feedkeys(escaped, "nx", false)
        vim.fn.cursor(0, col)
        vim.opt.virtualedit = "block"
    end
end

map("n", "<C-d>", straight_scroll("<C-d>", 4), { desc = "Scroll down (straight line)" })
map("n", "<C-u>", straight_scroll("<C-u>", -4), { desc = "Scroll up (straight line)" })

-- The partner of <C-f>. tmux keeps the first <C-b> as its prefix key.
map("n", "<C-j>", "<C-b>", { desc = "Scroll a page up" })

-- Insert blank lines without entering insert mode
map("n", "<leader>o", ":put _<CR>", { desc = "Insert line below", silent = true })
map("n", "<leader>O", ":put! _<CR>", { desc = "Insert line above", silent = true })

-- Neovim ships the undo tree as an optional plugin that only opens, so the
-- closing half is ours. Moving the cursor in that window moves the undo state.
map("n", "<leader>ut", function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "nvim-undotree" then
            vim.api.nvim_win_close(win, true)
            return
        end
    end
    vim.cmd("packadd nvim.undotree")
    vim.cmd("Undotree")
end, { desc = "Toggle undo tree" })
