# Qutebrowser Theme Configuration
# OneDarkPro color scheme for qutebrowser
# This file contains only theme-related settings

from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer

# Configuration objects (will be available when imported)
config: ConfigAPI
c: ConfigContainer

def apply_onedarkpro_theme(config, c):
    """Apply OneDarkPro theme to qutebrowser"""
    
    # =============================================================================
    # Color Palette Definition
    # =============================================================================
    
    colors = {
        # Base colors
        'bg_primary': '{{bg_primary}}',      # Main background
        'bg_secondary': '{{bg_secondary}}',  # Secondary background
        'bg_tertiary': '{{bg_tertiary}}',    # Tertiary background
        'fg_primary': '{{fg_primary}}',      # Primary text
        'fg_secondary': '{{fg_secondary}}',  # Secondary text
        'fg_tertiary': '{{fg_tertiary}}',    # Disabled/tertiary text
        
        # Accent colors
        'accent_blue': '{{accent_blue}}',    # Primary accent
        'accent_green': '{{accent_green}}',  # Success/confirmation
        'accent_yellow': '{{accent_yellow}}', # Warning
        'accent_red': '{{accent_red}}',      # Error/danger
        
        # Status colors
        'success': '{{success}}',
        'warning': '{{warning}}',
        'error': '{{error}}',
        'info': '{{info}}',
        
        # Border colors
        'border_active': '{{border_active}}',
        'border_inactive': '{{border_inactive}}',
    }

    # =============================================================================
    # Status Bar Theme
    # =============================================================================
    
    # Status bar background
    c.colors.statusbar.normal.bg = colors['bg_secondary']
    c.colors.statusbar.normal.fg = colors['fg_primary']
    
    # Status bar in insert mode
    c.colors.statusbar.insert.bg = colors['accent_green']
    c.colors.statusbar.insert.fg = colors['bg_primary']
    
    # Status bar in command mode
    c.colors.statusbar.command.bg = colors['accent_blue']
    c.colors.statusbar.command.fg = colors['bg_primary']
    
    # Status bar in passthrough mode
    c.colors.statusbar.passthrough.bg = colors['accent_yellow']
    c.colors.statusbar.passthrough.fg = colors['bg_primary']
    
    # Status bar progress
    c.colors.statusbar.progress.bg = colors['accent_blue']
    
    # Status bar URL colors
    c.colors.statusbar.url.fg = colors['fg_primary']
    c.colors.statusbar.url.success.http.fg = colors['fg_primary']
    c.colors.statusbar.url.success.https.fg = colors['accent_green']
    c.colors.statusbar.url.error.fg = colors['accent_red']
    c.colors.statusbar.url.warn.fg = colors['accent_yellow']
    c.colors.statusbar.url.hover.fg = colors['accent_blue']

    # =============================================================================
    # Tab Bar Theme
    # =============================================================================
    
    # Tab bar background
    c.colors.tabs.bar.bg = colors['bg_secondary']
    
    # Inactive tabs
    c.colors.tabs.odd.bg = colors['bg_secondary']
    c.colors.tabs.odd.fg = colors['fg_secondary']
    c.colors.tabs.even.bg = colors['bg_secondary']
    c.colors.tabs.even.fg = colors['fg_secondary']
    
    # Active tab
    c.colors.tabs.selected.odd.bg = colors['accent_blue']
    c.colors.tabs.selected.odd.fg = colors['bg_primary']
    c.colors.tabs.selected.even.bg = colors['accent_blue']
    c.colors.tabs.selected.even.fg = colors['bg_primary']
    
    # Tab indicators
    c.colors.tabs.indicator.start = colors['accent_yellow']
    c.colors.tabs.indicator.stop = colors['accent_green']
    c.colors.tabs.indicator.error = colors['accent_red']

    # =============================================================================
    # Completion Theme
    # =============================================================================
    
    # Completion background
    c.colors.completion.fg = colors['fg_primary']
    c.colors.completion.odd.bg = colors['bg_secondary']
    c.colors.completion.even.bg = colors['bg_tertiary']
    
    # Completion categories
    c.colors.completion.category.fg = colors['accent_blue']
    c.colors.completion.category.bg = colors['bg_primary']
    c.colors.completion.category.border.top = colors['bg_primary']
    c.colors.completion.category.border.bottom = colors['bg_primary']
    
    # Selected completion item
    c.colors.completion.item.selected.fg = colors['bg_primary']
    c.colors.completion.item.selected.bg = colors['accent_blue']
    c.colors.completion.item.selected.border.top = colors['accent_blue']
    c.colors.completion.item.selected.border.bottom = colors['accent_blue']
    
    # Completion match highlighting
    c.colors.completion.match.fg = colors['accent_yellow']
    
    # Completion scrollbar
    c.colors.completion.scrollbar.fg = colors['fg_tertiary']
    c.colors.completion.scrollbar.bg = colors['bg_secondary']

    # =============================================================================
    # Download Theme
    # =============================================================================
    
    c.colors.downloads.bar.bg = colors['bg_secondary']
    c.colors.downloads.start.fg = colors['bg_primary']
    c.colors.downloads.start.bg = colors['accent_blue']
    c.colors.downloads.stop.fg = colors['bg_primary']
    c.colors.downloads.stop.bg = colors['accent_green']
    c.colors.downloads.error.fg = colors['bg_primary']
    c.colors.downloads.error.bg = colors['accent_red']

    # =============================================================================
    # Hints Theme
    # =============================================================================
    
    c.colors.hints.fg = colors['bg_primary']
    c.colors.hints.bg = colors['accent_yellow']
    c.colors.hints.match.fg = colors['accent_red']

    # =============================================================================
    # Keyhints Theme
    # =============================================================================
    
    c.colors.keyhint.fg = colors['fg_primary']
    c.colors.keyhint.suffix.fg = colors['accent_yellow']
    c.colors.keyhint.bg = colors['bg_tertiary']

    # =============================================================================
    # Messages Theme
    # =============================================================================
    
    c.colors.messages.error.fg = colors['bg_primary']
    c.colors.messages.error.bg = colors['accent_red']
    c.colors.messages.error.border = colors['accent_red']
    
    c.colors.messages.warning.fg = colors['bg_primary']
    c.colors.messages.warning.bg = colors['accent_yellow']
    c.colors.messages.warning.border = colors['accent_yellow']
    
    c.colors.messages.info.fg = colors['bg_primary']
    c.colors.messages.info.bg = colors['accent_blue']
    c.colors.messages.info.border = colors['accent_blue']

    # =============================================================================
    # Prompts Theme
    # =============================================================================
    
    c.colors.prompts.fg = colors['fg_primary']
    c.colors.prompts.bg = colors['bg_secondary']
    c.colors.prompts.border = colors['border_active']
    c.colors.prompts.selected.bg = colors['accent_blue']
    c.colors.prompts.selected.fg = colors['bg_primary']

    # =============================================================================
    # Webpage Theme (Dark Mode)
    # =============================================================================
    
    # Force dark mode on websites when possible
    c.colors.webpage.darkmode.enabled = True
    c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
    c.colors.webpage.darkmode.threshold.foreground = 150
    c.colors.webpage.darkmode.threshold.background = 205
    # Never invert images to preserve QR codes and other important graphics
    c.colors.webpage.darkmode.policy.images = 'never'
    c.colors.webpage.darkmode.policy.page = 'smart'
    
    # Override website colors with theme
    c.colors.webpage.bg = colors['bg_primary']

    # =============================================================================
    # Font Configuration
    # =============================================================================
    
    # Use global font settings
    font_family = '{{font}}, JetBrains Mono, Fira Code, Source Code Pro, Consolas, monospace'
    font_size = '{{font_size}}pt'
    
    c.fonts.default_family = font_family
    c.fonts.default_size = font_size
    
    # Specific font settings
    c.fonts.completion.entry = f'{font_size} {font_family}'
    c.fonts.completion.category = f'bold {font_size} {font_family}'
    c.fonts.debug_console = f'{font_size} {font_family}'
    c.fonts.downloads = f'{font_size} {font_family}'
    c.fonts.hints = f'bold {font_size} {font_family}'
    c.fonts.keyhint = f'{font_size} {font_family}'
    c.fonts.messages.error = f'{font_size} {font_family}'
    c.fonts.messages.info = f'{font_size} {font_family}'
    c.fonts.messages.warning = f'{font_size} {font_family}'
    c.fonts.prompts = f'{font_size} {font_family}'
    c.fonts.statusbar = f'{font_size} {font_family}'
    c.fonts.tabs.selected = f'{font_size} {font_family}'
    c.fonts.tabs.unselected = f'{font_size} {font_family}'
