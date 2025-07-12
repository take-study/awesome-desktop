# Qutebrowser Configuration
# A modern configuration using global color variables from dotter configuration (OneDarkPro theme)

import os
from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer

# Load theme configuration
import sys
import os
config_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, config_dir)

try:
    from theme import apply_onedarkpro_theme
    # Apply theme
    apply_onedarkpro_theme(config, c)
except ImportError:
    pass  # Fallback if theme module not found

# Load configuration API
config: ConfigAPI = config  # type: ignore
c: ConfigContainer = c  # type: ignore
config.load_autoconfig()

# =============================================================================
# General Settings
# =============================================================================

# Set default page

# Downloads
c.downloads.location.directory = '~/Downloads'
c.downloads.location.prompt = False

# Content settings
c.content.javascript.enabled = True
c.content.geolocation = 'ask'
c.content.notifications.enabled = 'ask'
c.content.autoplay = False

# Image handling - ensure QR codes and important graphics display correctly
c.content.images = True  # Enable images
c.content.webgl = True   # Enable WebGL for better graphics rendering

# Privacy settings
c.content.cookies.accept = 'no-3rdparty'
c.content.headers.do_not_track = True

# Window settings
c.window.hide_decoration = True
c.scrolling.smooth = True

# =============================================================================
# Key Bindings
# =============================================================================

# Vim-style navigation
config.bind('h', 'scroll left')
config.bind('j', 'scroll down')
config.bind('k', 'scroll up')
config.bind('l', 'scroll right')

# Tab management
config.bind('J', 'tab-prev')
config.bind('K', 'tab-next')
config.bind('X', 'tab-close')
config.bind('u', 'undo')

# Quick navigation
config.bind('gg', 'scroll-to-perc 0')
config.bind('G', 'scroll-to-perc')
config.bind('d', 'scroll-page 0 0.5')
config.bind('<Ctrl-u>', 'scroll-page 0 -0.5')

# Search
config.bind('/', 'set-cmd-text /')
config.bind('n', 'search-next')
config.bind('N', 'search-prev')

# Zoom
config.bind('+', 'zoom-in')
config.bind('-', 'zoom-out')
config.bind('=', 'zoom')

# Toggle dark mode for better QR code visibility
config.bind('<Ctrl-Shift-d>', 'config-cycle colors.webpage.darkmode.enabled true false')

# Password Management with KeepassXC
# Note: Replace 'your-gpg-key-id' with your actual GPG key ID
# Example: config.bind('pw', 'spawn --userscript qute-keepassxc --key ABC1234')
config.bind('pw', 'spawn --userscript qute-keepassxc --key {{gpg-key}}', mode='normal')
config.bind('<Alt-Shift-u>', 'spawn --userscript qute-keepassxc --key {{gpg-key}}', mode='insert')
config.bind('<Ctrl-Shift-p>', 'spawn --userscript qute-keepassxc --totp --key {{gpg-key}}', mode='normal')
config.bind('<Ctrl-Shift-t>', 'spawn --userscript qute-keepassxc --totp --key {{gpg-key}}', mode='insert')

# Alternative password fill (without GPG, stores key in plain text - less secure)
config.bind('<Alt-p>', 'spawn --userscript qute-keepassxc --no-gpg', mode='insert')

# Developer tools
config.bind('<F12>', 'devtools')

config.bind('<Ctrl-Shift-t>', 'spawn --userscript translate --target_lang {{translate_target}}', mode="caret")  

# =============================================================================
# Search Engines
# =============================================================================

c.url.searchengines = {
    'DEFAULT': 'https://www.duckduckgo.com/?q={}',
    'g': 'https://www.google.com/search?q={}',
    'gh': 'https://github.com/search?q={}',
    'aw': 'https://wiki.archlinux.org/index.php?search={}',
    'w': 'https://en.wikipedia.org/wiki/Special:Search?search={}',
    'yt': 'https://www.youtube.com/results?search_query={}',
    'r': 'https://www.reddit.com/search/?q={}',
}

# =============================================================================
# Content Blocking
# =============================================================================

# Enable ad blocking (requires qutebrowser-adblock)
try:
    c.content.blocking.enabled = True
except:
    pass  # Ignore if adblock is not available

# =============================================================================
# Per-domain Settings
# =============================================================================

# Allow specific sites to use all features
config.set('content.javascript.enabled', True, '*://github.com/*')
config.set('content.javascript.enabled', True, '*://gitlab.com/*')
config.set('content.cookies.accept', 'all', '*://github.com')
config.set('content.cookies.accept', 'all', '*://gitlab.com')

# Password manager related settings
# Enable JavaScript for common login sites (needed for password filling)
config.set('content.javascript.enabled', True, '*://accounts.google.com/*')
config.set('content.javascript.enabled', True, '*://login.microsoftonline.com/*')
config.set('content.javascript.enabled', True, '*://*.amazonaws.com/*')
config.set('content.javascript.enabled', True, '*://auth0.com/*')

# Allow notifications for password manager feedback
config.set('content.notifications.enabled', True, 'qute://*')

# =============================================================================
# UI Tweaks
# =============================================================================

# Hide scrollbars
c.scrolling.bar = 'never'

# Smooth scrolling
c.scrolling.smooth = True

# Hide tabs when only one is open
c.tabs.show = 'multiple'

# Tab position
c.tabs.position = 'top'

# Status bar position
c.statusbar.show = 'in-mode'

# Completion settings
c.completion.height = '50%'
c.completion.open_categories = ['searchengines', 'quickmarks', 'bookmarks', 'history']

# =============================================================================
# Aliases
# =============================================================================

# Useful aliases
c.aliases = {
    'q': 'quit',
    'qa': 'quit --save',
    'w': 'session-save',
    'wq': 'quit --save',
    'reload-config': 'config-source',
    'hc': 'history-clear',
    # Password management aliases
    'pass': 'spawn --userscript qute-keepassxc',
    'password': 'spawn --userscript qute-keepassxc',
    'totp': 'spawn --userscript qute-keepassxc --totp',
    'otp': 'spawn --userscript qute-keepassxc --totp',
    'keepass': 'spawn --userscript qute-keepassxc',
}
