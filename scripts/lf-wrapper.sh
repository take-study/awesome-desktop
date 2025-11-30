#!/bin/sh
# IMPORTANT INFO
# THE SCRIPT REQUIRES LF config integration. Add
# "inportal" file to you lf config folder and include this line anywhere inside your
# main config (lfrc):
# cmd inportal source "~/.config/lf/inportal"
# The script also assumes you are using the {{terminal_cmd}} terminal.
# If you are using something else, adjust cmd variable accordingly.
#
# More technical info
# This wrapper script is invoked by xdg-desktop-portal-termfilechooser.
#
# Inputs:
# 1. "1" if multiple files can be chosen, "0" otherwise.
# 2. "1" if a directory should be chosen, "0" otherwise.
# 3. "0" if selecting files was requested, "1" if writing to a file was
#    requested. For example, when uploading files in Firefox, this will be "0".
#    When saving a web page in Firefox, this will be "1".
# 4. If writing to a file, this is recommended path provided by the caller. For
#    example, when saving a web page in Firefox, this will be the recommended
#    path Firefox provided, such as "~/Downloads/webpage_title.html".
#    Note that if the path already exists, we keep appending "_" to it until we
#    get a path that does not exist.
# 5. The output path, to which results should be written.
#
# Output:
# The script should print the selected paths to the output path (argument #5),
# one path per line.
# If nothing is printed, then the operation is assumed to have been canceled.

multiple="$1"
directory="$2"
save="$3"
path="$4"
output="$5"

cmd="/usr/bin/lf"
termcmd="{{terminal}}"
lfxdgbasedir=~/.config/lf/xdg-filepicker

if [ "$save" = "1" ]; then
    # make the saving appear in the last path
    set -- "$(dirname "$path")"
    FILENAME="$(basename "$path")"
    $termcmd $cmd \
        -command "set user_filename '$FILENAME'" \
        -command "source $lfxdgbasedir/save" "$@"
elif [ "$directory" = "1" ] && [ "$multiple" = "1" ] ; then
    $termcmd $cmd \
        -command "source $lfxdgbasedir/selectanything"
elif [ "$directory" = "1" ]; then
    $termcmd $cmd \
        -command "source $lfxdgbasedir/selectdir"
elif [ "$multiple" = "1" ]; then
    $termcmd $cmd \
        -command "source $lfxdgbasedir/selectfiles"
else
    $termcmd $cmd \
        -command "source $lfxdgbasedir/selectfile"
fi
