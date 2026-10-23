-- Loaded on the VeryLazy event. LazyVim's defaults:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Keys that belong to a plugin live in that plugin's file under lua/plugins:
-- in its keys table, or in its attach callback when the key is buffer-local.
local map = vim.keymap.set

-- The full path, because smerge is a shell alias that Neovim cannot see.
local SUBLIME_MERGE = "/Applications/Sublime Merge.app/Contents/SharedSupport/bin/smerge"

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

-- Sublime Merge finds the repository from the folder it starts in.
local function show_file_history()
    local file = vim.api.nvim_buf_get_name(0)
    vim.system({ SUBLIME_MERGE, "log", file }, { cwd = vim.fs.dirname(file) })
end

local function show_line_blame()
    local file = vim.api.nvim_buf_get_name(0)
    local line = tostring(vim.fn.line("."))
    vim.system({ SUBLIME_MERGE, "blame", file, line }, { cwd = vim.fs.dirname(file) })
end

local function show_repository()
    local repository = vim.fs.root(0, ".git")
    vim.system({ SUBLIME_MERGE, repository })
end

-- gmr lives in the zsh config, next to the private GitLab address, and -i is
-- what loads that config.
local function open_merge_request()
    local repository = vim.fs.root(0, ".git")
    vim.system({ "zsh", "-ic", "gmr" }, { cwd = repository, text = true }, function(result)
        if result.code ~= 0 then
            vim.schedule(function()
                vim.notify(vim.trim(result.stdout))
            end)
        end
    end)
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

-- Git

-- LazyVim opens this in a Snacks picker, where Enter checks the old version out over the file.
map("n", "<leader>gf", show_file_history, { desc = "File history in Sublime Merge" })
map("n", "<leader>go", show_repository, { desc = "Open repository in Sublime Merge" })
map("n", "<leader>gu", open_merge_request, { desc = "Open merge request" })

-- The small blame is the Gitsigns popup on <leader>gb. LazyVim's browser link
-- on this key cannot turn the amr-web remote into a GitLab page.
map("n", "<leader>gB", show_line_blame, { desc = "Blame in Sublime Merge" })

-- LazyVim's commit log pickers, where Enter checks out the commit.
vim.keymap.del("n", "<leader>gl")
vim.keymap.del("n", "<leader>gL")

-- Undo tree

map("n", "<leader>ut", toggle_undo_tree, { desc = "Toggle undo tree" })
