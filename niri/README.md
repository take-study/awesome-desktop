# Niri Configuration

This Niri configuration is based on the Hyprland setup in this dotfiles collection, providing a similar workflow and keybinding experience.

## Features

- **Keyboard-driven workflow** with vim-like navigation (hjkl)
- **Dynamic workspaces** with numbered workspace support (1-10)
- **Floating window support** with intelligent window rules
- **Application launcher** integration with tofi
- **Screenshot capabilities** with grimblast and swappy
- **Clipboard management** with cliphist
- **Volume control** with custom volume-control script
- **Auto-start applications** including fcitx5, dunst, and waybar

## Key Bindings

### Application Shortcuts
- `Super + Return`: Open terminal (alacritty with tmux)
- `Super + D`: Application launcher (tofi)
- `Super + E`: File manager (lf in alacritty)
- `Super + Q`: Close window
- `Super + Shift + E`: Quit niri
- `Super + C`: Calculator (tofi-calc)
- `Super + V`: Clipboard manager
- `Super + P`: Process manager (btm)

### Window Management
- `Super + F`: Toggle floating window
- `Super + Shift + F`: Fullscreen window
- `Super + V`: Toggle window floating
- `Super + Shift + V`: Switch focus between floating and tiling

### Navigation (Vim-like)
- `Super + H/J/K/L`: Focus left/down/up/right
- `Super + Left/Down/Up/Right`: Focus with arrow keys
- `Super + Shift + H/J/K/L`: Move window left/down/up/right
- `Super + Shift + Left/Down/Up/Right`: Move window with arrow keys

### Workspaces
- `Super + 1-9/0`: Switch to workspace 1-10
- `Super + Ctrl + 1-9/0`: Move window to workspace 1-10
- `Super + M`: Focus special workspace (workspace 11)
- `Super + Shift + M`: Move window to special workspace
- `Super + Mouse Wheel`: Navigate workspaces

### Window Resizing
- `Super + -/=`: Decrease/increase column width by 10%
- `Super + Shift + -/=`: Decrease/increase window height by 10%
- `Super + R`: Switch preset column width
- `Super + Shift + R`: Switch preset window height
- `Super + Ctrl + R`: Reset window height

### Multi-monitor Support
- `Super + Alt + H/J/K/L`: Focus monitor left/down/up/right
- `Super + Alt + Shift + H/J/K/L`: Move window to monitor left/down/up/right

### Screenshots
- `Super + S`: Screenshot full screen
- `Super + Shift + S`: Screenshot area
- `Print`: Take screenshot
- `Ctrl + Print`: Screenshot screen
- `Alt + Print`: Screenshot window

### Media Controls
- `XF86AudioRaiseVolume`: Volume up
- `XF86AudioLowerVolume`: Volume down
- `XF86AudioMute`: Toggle mute

### System
- `Super + O`: Toggle overview mode
- `Super + Shift + P`: Power off monitors
- `Super + Escape`: Toggle keyboard shortcuts inhibit (emergency)
- `Ctrl + Alt + Delete`: Quit with confirmation

## Window Rules

### Workspace Assignments
- **Workspace 1**: Terminal applications (Alacritty)
- **Workspace 2**: Web browsers (Firefox, Qutebrowser)
- **Workspace 3**: Code editors (VS Code, Zed)
- **Workspace 11**: Special workspace for KeePassXC and other utilities

### Floating Windows
- File manager windows
- Image viewers (imv)
- Media players (mpv)
- Process manager
- Firefox Picture-in-Picture

## Auto-start Applications

The configuration automatically starts:
- **fcitx5**: Input method framework
- **dunst**: Notification daemon
- **alacritty --daemon**: Terminal daemon for faster startup
- **cliphist**: Clipboard manager
- **swaybg**: Wallpaper manager
- **waybar**: Status bar
- **dbus-update-activation-environment**: Environment setup

## Installation and Usage

1. **Install dependencies**:
   ```bash
   # Core components
   sudo pacman -S niri alacritty dunst tofi fcitx5 swaybg waybar
   
   # Additional tools
   sudo pacman -S grimblast swappy cliphist lf btm tmux
   ```

2. **Deploy with dotter**:
   ```bash
   dotter deploy niri
   ```

3. **Start niri session**:
   ```bash
   # Use the provided session script
   ~/.local/bin/niri-session
   
   # Or start niri directly (environment variables need to be set manually)
   niri
   ```

4. **Set up wallpaper**:
   - Place your wallpaper at `~/Pictures/wallpaper/wall1.jpg`
   - Or modify the wallpaper path in the dotter configuration

## Environment Variables

The niri session script (`~/.local/bin/niri-session`) sets up proper environment variables for:
- **Cursor theme and size**
- **Qt/GTK Wayland support**
- **Input method (fcitx5)**
- **XDG desktop integration**
- **Portal support**

## Comparison with Hyprland

This Niri configuration provides similar functionality to the Hyprland setup:

### Similarities
- Same keybinding layout and muscle memory
- Identical application shortcuts
- Similar window management philosophy
- Same auto-start applications
- Equivalent workspace assignments

### Differences
- **Layout**: Niri uses scrollable tiling instead of traditional tiling
- **Workspaces**: Dynamic workspace system vs fixed workspaces
- **Animations**: Different animation system
- **Configuration**: KDL format vs Hyprland's custom format

## Troubleshooting

### Common Issues
1. **Applications not starting**: Check if all dependencies are installed
2. **Input method not working**: Ensure fcitx5 is running and configured
3. **Clipboard not working**: Verify cliphist and wl-paste are installed
4. **Wallpaper not showing**: Check if swaybg is installed and wallpaper path exists

### Debug Commands
```bash
# Check niri status
niri msg version

# List outputs
niri msg outputs

# Check running processes
niri msg windows
```

## Customization

To customize the configuration:
1. Modify `~/.config/niri/config.kdl` directly, or
2. Edit the source file `dotfiles/niri/config.kdl` and redeploy with dotter

Key areas to customize:
- **Keybindings**: Adjust in the `binds` section
- **Window rules**: Modify workspace assignments and floating rules
- **Layout**: Adjust gaps, column widths, and focus behavior
- **Startup applications**: Add or remove from `spawn-at-startup` lines

## Resources

- [Niri Wiki](https://github.com/YaLTeR/niri/wiki)
- [Niri Configuration Reference](https://github.com/YaLTeR/niri/wiki/Configuration:-Overview)
- [KDL Format Documentation](https://kdl.dev/)