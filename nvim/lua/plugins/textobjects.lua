return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
        require("nvim-treesitter.configs").setup({
            modules = {},
            sync_install = false,
            ignore_install = {},
            auto_install = true,
            ensure_installed = { "lua", "javascript", "typescript" },
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ib"] = "@block.inner",
                        ["ab"] = "@block.outer",
                        ["il"] = "@loop.inner",
                        ["al"] = "@loop.outer",
                        ["ic"] = "@conditional.inner",
                        ["ac"] = "@conditional.outer",
                        ["io"] = "@object.inner",
                        ["ao"] = "@object.outer",
                    },
                },
            },
        })
    end,
}
