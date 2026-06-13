-- Machine-local / work-specific Neovim config.
-- Copy to nvim/lua/config/local.lua (gitignored) and fill in your values.
-- Plugin specs load this via pcall(require, "config.local"), so it's safe to omit.

local M = {}

-- Extra Obsidian workspaces, appended to the public defaults in plugins/obsidian.lua.
-- M.obsidian_workspaces = {
--     { name = "work", path = "~/vaults/work" },
-- }

-- Project-specific fzf keymaps. Receives the loaded fzf-lua module and is
-- called from plugins/fzf.lua after fzf-lua loads.
-- function M.fzf_keymaps(fzf_lua)
--     vim.keymap.set("n", "<leader>pf", function()
--         fzf_lua.files({ cwd = "my-project", fzf_opts = { ["--layout"] = "reverse" } })
--     end, { desc = "Find files in my-project" })
-- end

return M
