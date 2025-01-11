local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

config.front_end = "OpenGL"
config.max_fps = 144
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500

config.color_scheme = "Kanagawa (Gogh)"
config.colors = {
	tab_bar = {
		background = "#1f1f28",
		active_tab = {
			bg_color = "#2d4f67",
			fg_color = "#dcd7ba",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#1f1f28",
			fg_color = "#dcd7ba",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		new_tab = {
			bg_color = "#1f1f28",
			fg_color = "#dcd7ba",
		},
	},
}
config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 14

config.window_decorations = "NONE | RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_close_confirmation = "NeverPrompt"
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true
config.tab_max_width = 999

local launch_menu = {}
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	table.insert(launch_menu, {
		label = "Powershell",
		args = { "powershell.exe" },
	})
	table.insert(launch_menu, {
		label = "Command Prompt",
		args = { "cmd.exe" },
	})
	table.insert(launch_menu, {
		label = "MSYS2 UCRT64",
		args = {
			"C:\\msys64\\msys2_shell.cmd",
			"-defterm",
			"-here",
			"-no-start",
			-- "-use-full-path",
			"-ucrt64",
			"-shell",
			"zsh",
		},
	})
	config.default_prog = {
		"C:\\msys64\\msys2_shell.cmd",
		"-defterm",
		"-here",
		"-no-start",
		-- "-use-full-path",
		"-ucrt64",
		"-shell",
		"zsh",
	}
end
config.launch_menu = launch_menu
config.default_cwd = os.getenv("MSYS2_HOME")

config.keys = {
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = act.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "z",
		mods = "CTRL|SHIFT",
		action = act.TogglePaneZoomState,
	},
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = act.RotatePanes("Clockwise"),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT|ALT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT|ALT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT|ALT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT|ALT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "h",
		mods = "CTRL|ALT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "k",
		mods = "CTRL|ALT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "CTRL|ALT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "j",
		mods = "CTRL|ALT",
		action = act.ActivatePaneDirection("Down"),
	},
}

return config
