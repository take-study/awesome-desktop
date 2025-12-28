#!/bin/sh
systemctl --user daemon-reload

{{#if dotter.packages.alacritty }}
systemctl --user enable alacritty.service
{{/if}}

{{#if dotter.packages.foot }}
systemctl --user enable foot.service
{{/if}}

{{#if dotter.packages.fcitx5 }}
systemctl --user enable fcitx5.service
{{/if}}

{{#if dotter.packages.dunst }}
systemctl --user enable dunst.service
{{/if}}

{{#if dotter.packages.hyprland }}
systemctl --user enable hypridle.service
systemctl --user enable hyprpaper.service
{{/if}}

{{#if dotter.packages.qutebrowser}}
chmod +x ~/.config/qutebrowser/userscripts/*
{{/if}}

{{#if dotter.packages.nvim}}
{{#if download_dependencies}}
cp -r dependencies/nvim/* ~/.local/share/nvim/
{{/if}}
{{/if}}
