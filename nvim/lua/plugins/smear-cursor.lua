return {
    "sphamba/smear-cursor.nvim",
    opts = function()
        return {
            cursor_color = vim.g.accent_color,
            stiffness = 0.8,
            trailing_stiffness = 0.6,
            damping = 0.95,
            distance_stop_animating = 0.5,
        }
    end,
}
