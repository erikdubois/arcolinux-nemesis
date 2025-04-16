# nlogout

`nlogout` is a customizable logout GUI application for Linux systems, written in Nim. It provides a configurable interface for logging out, shutting down, rebooting, and other system actions.

![Alt text](https://github.com/DrunkenAlcoholic/nlogout/blob/main/Custom.Catppuccin.Theme.To.Match.Status.Bar.png?raw=true "Example theme to match statusbar")

## Features

- Customizable buttons for various system actions (logout, reboot, shutdown, etc.)
- Configurable appearance (colors, fonts, icon themes)
- Support for rounded corners on buttons
- Keyboard shortcuts for quick actions
- Custom icon themes
- Support for custom lock screen applications
- Ability to terminate specified programs before logout

## Installation
 - Simply copy nlogout to /usr/bin or any other preferred directory, copy config.toml and the themes folder to ~/.config/nlogout
 - Bind a shortcut to nlogout

 ```
 mkdir -p "$HOME/.config/nlogout"

 cp ./bin/nlogout "$HOME/.config/nlogout/nlogout"
 cp config.toml "$HOME/.config/nlogout/config.toml"
 cp -r ./themes "$HOME/.config/nlogout/themes"
 ```

## Building from source

### Prerequisites

- Nim compiler
- nimble package manager (nimble)
   ```
   sudo pacman -S nim
   ```

- nim modules NiGUI and parseToml
   ```
   nimble install nigui
   nimble install parsetoml
   ```
### Build

1. Clone the repository:
   ```
   git clone https://github.com/DrunkenAlcoholic/nlogout.git
   cd nlogout
   ```
2. Build the binrary
   ```
   nim compile --define:release --opt:size --app:gui --outdir="./bin" src/nlogout.nim
   ```

3. Optionally Run the rebuild script:
   ```
   ./build.sh
   ```

   This script will:
   - Install Nim (if using Arch Linux)
   - Install required Nim modules (parsetoml, nigui)
   - Compile nlogout

 Note: You will need to manually copy themes, config.toml to ~/.config/nlogout, Also copy nlogout to /usr/bin or your preffered directory


## Configuration

nlogout uses a TOML configuration file located at `~/.config/nlogout/config.toml`. You can customize various aspects of the application, including:

- Window properties
- Font settings
- Button appearance and behavior
- Icon themes
- Custom lock screen application
- Programs to terminate before logout

For a detailed explanation of configuration options, see the [Configuration Guide](nlogout.Configuration.Guide.md).

## Usage

Run nlogout by executing:

```
~/.config/nlogout/nlogout
```

You can bind this command to a keyboard shortcut in your window manager or desktop environment for quick access.

## The rebuild.sh Script

The `rebuild.sh` script is provided for easy building and installation of nlogout. Here's what it does:

1. Terminates any running instance of nlogout
2. Installs Nim compiler (for Arch Linux users)
3. Installs required Nim modules
4. Compiles nlogout with optimizations
5. Copies the default configuration and themes if they don't exist

You can use this script to quickly rebuild and update your nlogout installation.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgements

- [nigui](https://github.com/simonkrauter/NiGui) for the GUI framework
- [parsetoml](https://github.com/NimParsers/parsetoml) for TOML parsing
