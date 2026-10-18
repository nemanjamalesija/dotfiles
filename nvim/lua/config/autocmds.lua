-- Loaded on the VeryLazy event. LazyVim's defaults:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
local MAX_OPEN_FILES = 10

-- clear = true makes re-sourcing this file replace the autocmds instead of adding copies.
local function augroup(name)
    return vim.api.nvim_create_augroup("my_" .. name, { clear = true })
end

local function turn_off_spell()
    vim.opt_local.spell = false
end

-- The tmux status bar shows the file.
local function tell_tmux_current_file()
    local file = vim.fn.expand("%:.")
    if file == "" then
        return
    end
    local command = string.format("tmux set -t %s @current_file '%s'", vim.env.TMUX_PANE, file)
    vim.fn.jobstart(command, { detach = true })
end

local function can_close(file)
    local is_current = file.bufnr == vim.api.nvim_get_current_buf()
    local is_shown = #file.windows > 0
    local has_unsaved_changes = file.changed == 1
    return not is_current and not is_shown and not has_unsaved_changes
end

local function close_least_recent_file()
    local files = vim.fn.getbufinfo({ buflisted = 1 })
    if #files <= MAX_OPEN_FILES then
        return
    end
    table.sort(files, function(a, b)
        return (a.lastused or 0) < (b.lastused or 0)
    end)
    for _, file in ipairs(files) do
        if can_close(file) then
            pcall(vim.cmd, "bdelete " .. file.bufnr)
            return
        end
    end
end

-- Wiring

-- LazyVim turns spell checking on for these file types.
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("no_spell"),
    pattern = { "markdown", "text", "gitcommit" },
    callback = turn_off_spell,
})

if vim.env.TMUX then
    vim.api.nvim_create_autocmd("BufEnter", {
        group = augroup("tmux_current_file"),
        callback = tell_tmux_current_file,
    })
end

vim.api.nvim_create_autocmd("BufAdd", {
    group = augroup("max_open_files"),
    callback = function()
        vim.schedule(close_least_recent_file)
    end,
})
