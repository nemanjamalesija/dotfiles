return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "query",
          "php",
          "html",
          "css",
          "scss",
          "javascript",
          "typescript",
          "vue",
          "twig",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = false,
        modules = {},
        ignore_install = {},
      })
    end,
  },
}
