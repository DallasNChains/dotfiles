local wezterm = require 'wezterm'
local config  = wezterm.config_builder()
local act = wezterm.action

-- Colors and fonts

config.colors = {
  foreground    = '#444C5C',
  background    = '#E5F6FF',
  cursor_bg     = '#0077B3',
  cursor_fg     = '#444C5C',
  cursor_border = '#0077B3',
  selection_fg  = '#383A42',
  selection_bg  = '#C4C9D4',

  ansi = {
    '#444C5C', -- black
    '#9B1600', -- red
    '#219C16', -- green
    '#757009', -- yellow
    '#0A4869', -- blue
    '#812181', -- magenta
    '#174E4E', -- cyan
    '#534949', -- white
  },
  brights = {
    '#576175', -- bright black
    '#B43A24', -- bright red
    '#1F6A1A', -- bright green
    '#CD8705', -- bright yellow
    '#0F6A9B', -- bright blue
    '#B32DB3', -- bright magenta
    '#1E6767', -- bright cyan
    '#6C6C6C', -- bright white
  },

  scrollbar_thumb = '#576175',

  tab_bar = {
    background = '#C4C9D4',

    active_tab = {
      bg_color = '#E5F6FF',
      fg_color = '#444C5C',
      intensity = 'Bold',
    },

    inactive_tab = {
      bg_color = '#C4C9D4',
      fg_color = '#444C5C',
    },

    inactive_tab_hover = {
      bg_color = '#576175',
      fg_color = '#FAFAFA',
    },

    new_tab = {
      bg_color = '#C4C9D4',
      fg_color = '#444C5C',
    },
    new_tab_hover = {
      bg_color = '#0077B3',
      fg_color = '#FAFAFA',
    },
  }
}

config.window_frame = {
  active_titlebar_bg = '#C4C9D4',
  inactive_titlebar_bg = '#C4C9D4',
}

config.font = wezterm.font('JetBrainsMono Nerd Font Mono', { weight = 'Medium' })
config.font_size = 14.0

-- Window config

config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.initial_cols = 120
config.initial_rows  = 50
config.scrollback_lines = 999999
config.default_cwd = wezterm.home_dir .. '/Code'
config.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
config.window_background_opacity = 0.95
config.window_close_confirmation = 'NeverPrompt'
config.show_tab_index_in_tab_bar = false
config.enable_scroll_bar = true

-- Input handling
local mod = wezterm.target_triple:find('darwin') and 'SUPER' or 'CTRL'

config.mouse_bindings = {
  {
    event  = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}

-- Copy
config.keys = {
  {
    key = 'c', mods = mod,
    action = wezterm.action_callback(function(window, pane)
      if window:get_selection_text_for_pane(pane) ~= '' then
        window:perform_action(act.CopyTo 'ClipboardAndPrimarySelection', pane)
      else
        window:perform_action(act.SendKey { key = 'c', mods = 'CTRL' }, pane)
      end
    end),
  },

  -- Paste
  { key = 'v', mods = mod, action = act.PasteFrom 'Clipboard' },

  -- Tabs
  { key = 't', mods = mod, action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = mod, action = act.CloseCurrentTab { confirm = false } },
  { key = '[', mods = mod, action = act.ActivateTabRelative(-1) },
  { key = ']', mods = mod, action = act.ActivateTabRelative(1) },
  { key = '1', mods = mod, action = act.ActivateTab(0) },
  { key = '2', mods = mod, action = act.ActivateTab(1) },
  { key = '3', mods = mod, action = act.ActivateTab(2) },
  { key = '4', mods = mod, action = act.ActivateTab(3) },
  { key = '5', mods = mod, action = act.ActivateTab(4) },

  -- Navigate panes
  { key = 'LeftArrow', mods = mod, action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = mod, action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = mod, action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = mod, action = act.ActivatePaneDirection 'Down' },

  -- Find
  { key = 'f', mods = mod, action = act.Search { CaseSensitiveString = '' } },
}

-- Notifications
config.audible_bell = 'Disabled'
config.visual_bell  = {
  fade_in_function     = 'EaseIn',
  fade_in_duration_ms  = 30,
  fade_out_function    = 'EaseOut',
  fade_out_duration_ms = 30,
}

-- Windows bullshit
config.default_prog = { 'wsl.exe', '--distribution', 'Ubuntu', '--cd', '~/Code' }
config.default_domain = 'WSL:Ubuntu'

-- Override the question if I want to close the tab
wezterm.on('mux-is-process-stateful', function(_proc)
  return false
end)

wezterm.on("gui-startup", function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():focus()
end):

return config