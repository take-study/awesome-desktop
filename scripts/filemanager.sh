#!/bin/sh
if [[ $# -lt 1 ]]; then
    {{terminal}} {{class_arg}} "file-manager" {{filemanager_cmd}}
else
    {{terminal}} {{class_arg}} "file-manager" {{filemanager_cmd}} $1
fi
