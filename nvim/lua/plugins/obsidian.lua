-- Work/project vaults live in the gitignored nvim/lua/config/local.lua;
-- the public default below is just the personal vault.
local workspaces = {}
local ok, localcfg = pcall(require, "config.local")
if ok and type(localcfg) == "table" and localcfg.obsidian_workspaces then
    vim.list_extend(workspaces, localcfg.obsidian_workspaces)
end
table.insert(workspaces, { name = "personal", path = "~/vaults/personal" })

return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true, -- Changed to true
    cmd = {
        "ObsidianOpen",
        "ObsidianNew",
        "ObsidianQuickSwitch",
        "ObsidianSearch",
        "ObsidianWorkspace",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = workspaces,
        ui = {
            enable = false,
        },
    },
}
