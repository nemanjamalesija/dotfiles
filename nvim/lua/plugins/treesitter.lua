return {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, {
            "bash",
            "c",
            "diff",
            "html",
            "css",
            "scss",
            "javascript",
            "typescript",
            "tsx",
            "vue",
            "jsdoc",
            "json",
            "jsonc",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "printf",
            "query",
            "regex",
            "toml",
            "vim",
            "vimdoc",
            "xml",
            "yaml",
            "twig",
        })
        opts.incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-space>",
                node_incremental = "<C-space>",
                scope_incremental = false,
                node_decremental = "<bs>",
            },
        }
    end,
}
