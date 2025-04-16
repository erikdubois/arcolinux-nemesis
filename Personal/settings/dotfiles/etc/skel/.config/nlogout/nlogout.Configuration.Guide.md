# nlogout Configuration Guide

This guide explains all the configuration options available in the `config.toml` file for nlogout. The configuration file is located at `~/.config/nlogout/config.toml`.

## Table of Contents

1. [Button Order](#button-order)
2. [Programs to Terminate](#programs-to-terminate)
3. [Lock Screen Application](#lock-screen-application)
4. [Window Configuration](#window-configuration)
5. [Font Configuration](#font-configuration)
6. [Global Button Configuration](#global-button-configuration)
7. [Individual Button Configurations](#individual-button-configurations)

## Button Order

```toml
button_order = ["cancel", "logout", "reboot", "shutdown", "lock", "suspend", "hibernate"]
```

This optional setting allows you to specify the order in which buttons appear. If not specified, all configured buttons will be shown in the order they are defined in the config file.

## Programs to Terminate

```toml
programs_to_terminate = ["example_program1", "example_program2"]
```

Specify a list of programs that should be terminated when logging out. This ensures there is only one instance when logging back in.

## Lock Screen Application

```toml
lock_screen_app = "i3lock -c 313244"
```

Optionally specify a custom lock screen application command. If not set, the default `loginctl lock-session` will be used.

## Window Configuration

```toml
[window]
width = 642
height = 98
title = "nlogout"
background_color = "#313244"
```

- `width`: Width of the application window (in pixels)
- `height`: Height of the application window (in pixels)
- `title`: The title of the application window
- `background_color`: The background color of the application window (in hex format)

## Font Configuration

```toml
[font]
family = "Noto Sans Mono"
size = 14
bold = true
```

- `family`: The font family used in the application
- `size`: The font size used in the application
- `bold`: Whether to use bold font (true/false)

## Global Button Configuration

```toml
[button]
show_text = true
width = 80
height = 80
padding = 3
top_padding = 3
corner_radius = 10
icon_size = 32
icon_theme = "default"
```

- `show_text`: Whether to show text on buttons (true/false). If set to false, only icons will be displayed.
- `width`: Width of each button (in pixels)
- `height`: Height of each button (in pixels)
- `padding`: Padding between buttons (in pixels)
- `top_padding`: Padding at the top of each button (in pixels)
- `corner_radius`: Radius of rounded corners, setting 0 means square buttuns
- `icon_size`: Size of the icons for all buttons (in pixels)
- `icon_theme`: Name of the icon theme folder (located in `~/.config/nlogout/themes/`)

## Individual Button Configurations

For each button (`cancel`, `logout`, `reboot`, `shutdown`, `lock`, `suspend`, `hibernate`), you can specify:

```toml
[buttons.cancel]
text = "Cancel"
background_color = "#f5e0dc"
text_color = "#363a4f"
shortcut = "Escape"
```

- `text`: The text displayed on the button
- `background_color`: The background color of the button (in hex format)
- `text_color`: The text color of the button (in hex format)
- `shortcut`: The keyboard shortcut for the button action

Repeat this section for each button you want to include in your configuration.

## Icon Themes

Icons should be placed in the `~/.config/nlogout/themes/` directory, in a subdirectory named after your theme. For example:

```
~/.config/nlogout/themes/default/cancel.svg
~/.config/nlogout/themes/default/logout.svg
# ... etc.
```

Ensure that your icon theme directory contains an SVG file for each button, named exactly as the button key (e.g., `cancel.svg`, `logout.svg`, etc.).
