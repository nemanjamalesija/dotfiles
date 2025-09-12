local wezterm = require("wezterm")

-- List of color schemes to rotate through
local themes = {
	"Builtin Solarized Light",
	"Dark+",
	"catppuccin-latte",
	"catppuccin-macchiato",
	"Poimandres",
	-- "gruber-darker",
	-- "Obsidian",
	-- "OceanicMaterial",
	-- "tokyonight-storm",
}

-- Set your default theme
local default_theme = "Builtin Solarized Light"

-- Pick opacity based on theme
-- local function initial_opacity(theme)
-- 	if theme == "Builtin Solarized Light" then
-- 		return 1.0
-- 	elseif theme == "Spring" then
-- 		return 1.0
-- 	else
-- 		return 0.99
-- 	end
-- end

-- Toggle logic
local function rotate_theme(window, pane)
	local overrides = window:get_config_overrides() or {}
	local current = overrides.color_scheme or default_theme

	-- Find next theme
	local index = 1
	for i, theme in ipairs(themes) do
		if theme == current then
			index = i
			break
		end
	end
	local next_theme = themes[(index % #themes) + 1]

	-- Apply theme + opacity
	overrides.color_scheme = next_theme
	-- overrides.window_background_opacity = initial_opacity(next_theme)
	window:set_config_overrides(overrides)
end

return {
	-- GPU acceleration for macOS
	front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",
	max_fps = 120,
	window_decorations = "NONE",
	enable_tab_bar = false,
	-- hide_tab_bar_if_only_one_tab = false,
	-- show_new_tab_button_in_tab_bar = false,
	-- show_tab_index_in_tab_bar = false,
	-- show_tabs_in_tab_bar = false,
	-- tab_and_split_indices_are_zero_based = false,
	-- tab_max_width = 25,
	switch_to_last_active_tab_when_closing_tab = true,
	line_height = 1.1,
	use_fancy_tab_bar = true,
	adjust_window_size_when_changing_font_size = true,
	-- font = wezterm.font("RobotoMono Nerd Font"),
	font = wezterm.font("Consolas"),
	font_size = 20,
	color_scheme = default_theme,
	window_background_opacity = 1.0,
	alternate_buffer_wheel_scroll_speed = 0,
	window_close_confirmation = "NeverPrompt",
	enable_wayland = false,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	keys = {
		{
			key = "t",
			mods = "CTRL|SHIFT",
			action = wezterm.action_callback(rotate_theme),
		},
		{
			key = "w",
			mods = "CMD",
			action = wezterm.action.CloseCurrentTab({ confirm = false }),
		},
	},
}
