#!/bin/sh
if [[ $# -lt 1 ]]; then
    {{terminal}} {{class_arg}} "editor" nvim
else
    {{terminal}} {{class_arg}} "editor" nvim $1
fi
