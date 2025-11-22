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
        workspaces = {
            { name = "njuskalo", path = "~/vaults/njuskalo" },
            { name = "emasys", path = "~/vaults/emasys" },
            { name = "personal", path = "~/vaults/personal" },
        },
        ui = {
            enable = false,
        },
    },
}
