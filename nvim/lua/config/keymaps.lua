-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- -- Add this to ~/.config/nvim/lua/config/keymaps.lua (if using LazyVim)
-- or add to your init.lua if you have a different setup
local map = vim.keymap.set

-- File operations
map("n", "<leader>fw", "<cmd>w<cr>", { desc = "Save File" })

-- Close current buffer
map("n", "<leader>qb", "<cmd>bdelete<cr>", { desc = "Quit Buffer" })

vim.api.nvim_create_user_command("W", "w", {})

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

-- Obsidian (prefix <leader>N = Notes; <leader>O/<leader>o stay as insert-line maps)
map("n", "<leader>Nn", ":ObsidianNew<CR>", { desc = "Obsidian: New Note in Workspace" })
map("n", "<leader>Ns", ":ObsidianSearch<CR>", { desc = "Obsidian: Search Notes in Workspace" })
map("n", "<leader>Nl", ":ObsidianQuickSwitch<CR>", { desc = "Obsidian: List Notes in Workspace" })
map("n", "<leader>Nt", ":ObsidianToday<CR>", { desc = "Obsidian: Notes for today" })
map("n", "<leader>Nw", ":ObsidianWorkspace<CR>", { desc = "Obsidian: List Workspaces" })

-- Cross-vault navigation: one picker over ALL vaults under ~/vaults.
-- Opening a note auto-switches the active Obsidian workspace (BufEnter handler),
-- so there's no need to change workspace first. Force-load obsidian.nvim so that
-- handler is registered before the note opens.
local obsidian_root = vim.fn.expand("~/vaults")

-- Move one or more notes to the system Trash (recoverable, via macOS `trash`),
-- after a confirmation. Also wipes any open buffer pointing at a trashed file.
local function obsidian_trash(files)
    files = vim.tbl_filter(function(f)
        return f and f ~= "" and vim.fn.filereadable(f) == 1
    end, files or {})
    if #files == 0 then
        vim.notify("No note to delete", vim.log.levels.WARN)
        return
    end

    local prompt = #files == 1 and ("Move to Trash?\n" .. files[1])
        or ("Move " .. #files .. " notes to Trash?")
    if vim.fn.confirm(prompt, "&Yes\n&No", 2) ~= 1 then
        return
    end

    local out = vim.fn.system(vim.list_extend({ "trash" }, vim.deepcopy(files)))
    if vim.v.shell_error ~= 0 then
        vim.notify("trash failed: " .. out, vim.log.levels.ERROR)
        return
    end

    for _, f in ipairs(files) do
        local b = vim.fn.bufnr(f)
        if b ~= -1 then
            pcall(vim.api.nvim_buf_delete, b, { force = true })
        end
    end
    vim.notify(string.format("Trashed %d note%s", #files, #files == 1 and "" or "s"))
end

map("n", "<leader>Nf", function()
    require("lazy").load({ plugins = { "obsidian.nvim" } })
    require("fzf-lua").files({
        prompt = "ObsidianNotes❯ ",
        cwd = obsidian_root,
        fd_opts = "--type f --extension md --color=never",
        fzf_opts = { ["--layout"] = "reverse" },
        -- <Enter> opens; <Ctrl-x> trashes the selected note(s) (multi-select with <Tab>).
        actions = {
            ["default"] = require("fzf-lua.actions").file_edit_or_qf,
            ["ctrl-x"] = function(selected, opts)
                local entry_to_file = require("fzf-lua.path").entry_to_file
                local files = {}
                for _, sel in ipairs(selected) do
                    files[#files + 1] = entry_to_file(sel, opts).path
                end
                obsidian_trash(files)
            end,
        },
    })
end, { desc = "Obsidian: Find note across ALL vaults (<C-x> to trash)" })

map("n", "<leader>Nd", function()
    obsidian_trash({ vim.api.nvim_buf_get_name(0) })
end, { desc = "Obsidian: Delete (Trash) current note" })

map("n", "<leader>Ng", function()
    require("lazy").load({ plugins = { "obsidian.nvim" } })
    require("fzf-lua").live_grep({
        prompt = "ObsidianGrep❯ ",
        cwd = obsidian_root,
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --type md",
        fzf_opts = { ["--layout"] = "reverse" },
        winopts = { preview = { hidden = false } },
    })
end, { desc = "Obsidian: Grep note contents across ALL vaults" })

-- Create a new note in a CHOSEN vault (vs <leader>Nn which uses the current one).
-- Pick vault -> enter title -> note is created directly in that vault's dir via
-- create_note{ dir = ... }, so no workspace switch/lock is needed; opening it lets
-- the BufEnter handler activate that workspace. Vaults come from obsidian's own
-- resolved workspace list, so this stays in sync with config.local.
map("n", "<leader>NN", function()
    require("lazy").load({ plugins = { "obsidian.nvim" } })
    local client = require("obsidian").get_client()
    local workspaces = client.opts.workspaces
    local names = vim.tbl_map(function(ws)
        return ws.name
    end, workspaces)

    vim.ui.select(names, { prompt = "New Obsidian note in vault:" }, function(choice)
        if not choice then
            return
        end

        local dir
        for _, ws in ipairs(workspaces) do
            if ws.name == choice then
                dir = vim.fn.expand(tostring(ws.path))
                break
            end
        end

        vim.ui.input({ prompt = "Title (optional): " }, function(title)
            if title == nil then
                return -- cancelled
            end
            if title == "" then
                title = nil
            end
            local note = client:create_note({ title = title, dir = dir, no_write = true })
            client:open_note(note, { sync = true })
            client:write_note_to_buffer(note)
        end)
    end)
end, { desc = "Obsidian: New note in chosen vault" })

-- Straight-line scroll: temporarily enable virtualedit during C-d/C-u
local function straight_scroll(key)
    return function()
        local col = vim.fn.virtcol(".")
        vim.opt.virtualedit = "all"
        local escaped = vim.api.nvim_replace_termcodes(key, true, false, true)
        vim.api.nvim_feedkeys(escaped, "nx", false)
        vim.fn.cursor(0, col)
        vim.opt.virtualedit = "block"
    end
end

map("n", "<C-d>", straight_scroll("<C-d>"), { desc = "Scroll down (straight line)" })
map("n", "<C-u>", straight_scroll("<C-u>"), { desc = "Scroll up (straight line)" })

-- Insert blank lines without entering insert mode
map("n", "<leader>o", ":put _<CR>", { desc = "Insert line below", silent = true })
map("n", "<leader>O", ":put! _<CR>", { desc = "Insert line above", silent = true })
