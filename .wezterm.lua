local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- General
config.front_end = "OpenGL"
config.max_fps = 144
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500

-- Colors
config.color_scheme = "Kanagawa (Gogh)"
config.colors = {
	tab_bar = {
		background = "#1f1f28",
		active_tab = {
			bg_color = "#2d4f67",
			fg_color = "#dcd7ba",
		},
		inactive_tab = {
			bg_color = "#1f1f28",
			fg_color = "#877d44",
		},
		new_tab = {
			bg_color = "#1f1f28",
			fg_color = "#877d44",
		},
	},
}

-- Fonts
config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 14

-- Windows
config.window_decorations = "NONE | RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_close_confirmation = "NeverPrompt"

-- Tabs
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true
config.tab_max_width = 32

local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
local THIN_RIGHT_ARROW = wezterm.nerdfonts.pl_left_soft_divider
local function tab_title(tab, max_width)
	local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title
	title = wezterm.truncate_right(title, max_width - 3)
	return title
end

local function tab_curr_idx(tabs, tab)
	local idx = 0
	for i, t in ipairs(tabs) do
		if t.tab_id == tab.tab_id then
			idx = i
			break
		end
	end
	return idx
end

local function tab_curr_meta(idx, tab)
	local mux_tab = wezterm.mux.get_tab(tab.tab_id)
	local panes = mux_tab:panes_with_info()
	local npanes = #panes
	if npanes == 1 then
		return tostring(idx)
	end
	local subscript = {
		[1] = "₁",
		[2] = "₂",
		[3] = "₃",
		[4] = "₄",
		[5] = "₅",
		[6] = "₆",
		[7] = "₇",
		[8] = "₈",
		[9] = "₉",
		[10] = "x",
	}
	local is_zoomed = false
	for _, pane in ipairs(panes) do
		if pane.is_zoomed then
			is_zoomed = true
			break
		end
	end

	local sub = "₍" .. (npanes > 9 and subscript[10] or subscript[npanes]) .. "₎"
	if is_zoomed and npanes > 1 then
		return "" .. sub
	end
	return idx .. sub
end

local tab_format = {
	{ Background = { Color = nil } },
	{ Foreground = { Color = nil } },
	{ Text = nil },
	{ Background = { Color = nil } },
	{ Foreground = { Color = nil } },
	{ Text = nil },
}
wezterm.on("format-tab-title", function(tab, tabs, _, conf, _, max_width)
	local tab_bar = conf.colors.tab_bar
	local active_bg = tab_bar.active_tab.bg_color
	local active_fg = tab_bar.active_tab.fg_color
	local inactive_bg = tab_bar.inactive_tab.bg_color
	local inactive_fg = tab_bar.inactive_tab.fg_color
	local bg = tab_bar.background
	local title = tab_title(tab, max_width)
	local tab_idx = tab_curr_idx(tabs, tab)
	local is_last = tab_idx == #tabs
	local meta = tab_curr_meta(tab_idx, tab)
	local tab_text = string.format(" %s %s ", meta, title)
	if tab.is_active then
		tab_format[1].Background.Color = active_bg
		tab_format[2].Foreground.Color = active_fg
		tab_format[3].Text = tab_text
		tab_format[4].Background.Color = bg
		tab_format[5].Foreground.Color = active_bg
		tab_format[6].Text = SOLID_RIGHT_ARROW
		return tab_format
	end
	tab_format[1].Background.Color = inactive_bg
	tab_format[2].Foreground.Color = inactive_fg
	tab_format[3].Text = tab_text
	if is_last then
		tab_format[4].Background.Color = bg
		tab_format[5].Foreground.Color = inactive_fg
		tab_format[6].Text = THIN_RIGHT_ARROW
		return tab_format
	end
	local next_tab = tabs[tab_idx + 1]
	if next_tab.is_active then
		tab_format[4].Background.Color = active_bg
		tab_format[5].Foreground.Color = inactive_bg
		tab_format[6].Text = SOLID_RIGHT_ARROW
	else
		tab_format[4].Background.Color = inactive_bg
		tab_format[5].Foreground.Color = inactive_fg
		tab_format[6].Text = THIN_RIGHT_ARROW
	end
	return tab_format
end)

-- Startup
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

-- Key bindings
config.keys = {
	{
		key = "l",
		mods = "ALT",
		action = act.ShowLauncher,
	},
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
		key = "o",
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
