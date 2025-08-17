-- Set up the monokai-pro colorscheme with background color override
require("monokai-pro").setup({
  override = function(colors)
    return {
      Normal = { bg = "#1a1a1a" }, -- Black background for the Normal group
      -- You can override other groups similarly
      -- Comment = { fg = colors.green, italic = true },
    }
  end,
})

-- Apply the colorscheme
vim.cmd("colorscheme monokai-pro")
