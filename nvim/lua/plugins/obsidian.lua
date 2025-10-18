return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            { name = "njuskalo", path = "~/vaults/njuskalo" },
            { name = "emasys", path = "~/vaults/emasys" },
            { name = "personal", path = "~/vaults/personal" },
        },
    },
}
