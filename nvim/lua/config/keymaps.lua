-- Loaded on the VeryLazy event. LazyVim's defaults:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Keys that belong to a plugin live in that plugin's file under lua/plugins:
-- in its keys table, or in its attach callback when the key is buffer-local.
local map = vim.keymap.set

-- Copy the open file's path, relative to the project folder, to the clipboard.
local function copy_file_path()
    local path = vim.fn.expand("%:.")
    vim.fn.setreg("+", path)
    vim.notify("Copied " .. path)
end

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

-- Put the current file's diagnostics in the quickfix list, not the whole workspace's.
local function show_file_diagnostics()
    local diagnostics = vim.diagnostic.get(0)
    local items = vim.diagnostic.toqflist(diagnostics)
    vim.fn.setqflist({}, " ", { title = "Diagnostics", items = items })
    vim.cmd("copen")
end

-- Neovim ships the undo tree as an optional plugin that only opens, so the
-- closing half is ours. Moving the cursor in that window moves the undo state.
local function toggle_undo_tree()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "nvim-undotree" then
            vim.api.nvim_win_close(win, true)
            return
        end
    end
    vim.cmd("packadd nvim.undotree")
    vim.cmd("Undotree")
end

-- Files

-- Saving is silent so the file name and byte count stop being announced on
-- every write. A write that actually fails still reports itself, since plain
-- silent only hides ordinary messages.
map("n", "<leader>fw", "<cmd>silent w<cr>", { desc = "Save File" })

-- LazyVim maps this to a loud write.
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>silent w<cr><esc>", { desc = "Save File" })

vim.api.nvim_create_user_command("W", "silent w", {})
vim.api.nvim_create_user_command("CopyPath", copy_file_path, { desc = "Copy file path" })
map("n", "<C-y>", copy_file_path, { desc = "Copy file path" })

-- Panes

-- Close the current pane. Its file stays open for <leader>bd to close.
map("n", "<leader>qb", "<cmd>close<cr>", { desc = "Close Pane" })

map("n", "<leader>\\", "<cmd>vsplit<cr>", { desc = "Split pane vertically" })
map("n", "<M-i>", "<cmd>vertical resize +5<cr>", { desc = "Increase pane width" })
map("n", "<M-d>", "<cmd>vertical resize -5<cr>", { desc = "Decrease pane width" })
map("n", "<M-I>", "<cmd>resize +5<cr>", { desc = "Increase pane height" })
map("n", "<M-D>", "<cmd>resize -5<cr>", { desc = "Decrease pane height" })

-- Scrolling

map("n", "<C-d>", straight_scroll("<C-d>", 4), { desc = "Scroll down (straight line)" })
map("n", "<C-u>", straight_scroll("<C-u>", -4), { desc = "Scroll up (straight line)" })

-- The partner of <C-f>. tmux keeps the first <C-b> as its prefix key.
map("n", "<C-j>", "<C-b>", { desc = "Scroll a page up" })

-- Editing

-- Insert blank lines without entering insert mode
map("n", "<leader>o", ":put _<CR>", { desc = "Insert line below", silent = true })
map("n", "<leader>O", ":put! _<CR>", { desc = "Insert line above", silent = true })

-- Diagnostics

map("n", "<leader>cq", show_file_diagnostics, { desc = "See Quickfix List for Current Buffer" })

-- Undo tree

map("n", "<leader>ut", toggle_undo_tree, { desc = "Toggle undo tree" })
