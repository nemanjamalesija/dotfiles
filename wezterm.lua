local wezterm = require("wezterm")

-- List of color schemes to rotate through
local themes = {
	"Builtin Solarized Light",
	"Spring",
	-- "gruber-darker",
	-- "Obsidian",
	-- "OceanicMaterial",
	"catppuccin-mocha",
	"tokyonight-storm",
}

-- Set your default theme
local default_theme = "Builtin Solarized Light"

-- Pick opacity based on theme
local function initial_opacity(theme)
	if theme == "Builtin Solarized Light" then
		return 1.0
	elseif theme == "Spring" then
		return 1.0
	else
		return 0.95
	end
end

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
	overrides.window_background_opacity = initial_opacity(next_theme)
	window:set_config_overrides(overrides)
end

return {
	window_decorations = "RESIZE",
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = false,
	show_new_tab_button_in_tab_bar = true,
	show_tab_index_in_tab_bar = false,
	show_tabs_in_tab_bar = true,
	switch_to_last_active_tab_when_closing_tab = true,
	tab_and_split_indices_are_zero_based = false,
	tab_max_width = 25,
	use_fancy_tab_bar = true,
	adjust_window_size_when_changing_font_size = false,
	font = wezterm.font("RobotoMono Nerd Font"),
	font_size = 18,
	color_scheme = default_theme,
	window_background_opacity = initial_opacity(default_theme),
	alternate_buffer_wheel_scroll_speed = 0,
	max_fps = 120,
	window_close_confirmation = "NeverPrompt",
	keys = {
		{
			key = "t",
			mods = "CTRL|SHIFT",
			action = wezterm.action_callback(rotate_theme),
		},
	},
}
