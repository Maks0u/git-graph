#!/bin/sh
set -eu

# Compatibility check
command -v git >/dev/null || ( printf 'git not found\n' && exit 1 )
command -v awk >/dev/null || ( printf 'awk not found\n' && exit 1 )
command -v sort >/dev/null || ( printf 'sort not found\n' && exit 1 )
command -v head >/dev/null || ( printf 'head not found\n' && exit 1 )

# Context check
git rev-parse >/dev/null 2>&1 || ( printf 'not a git repository\n' && exit 1 )

# Calculate viewport width
terminalWidth=$(tput cols 2>/dev/null || printf '80')
width="${GIT_GRAPH_WIDTH:-$((terminalWidth - 1))}"

# Calculate maximum width of the graph
graphWidth=$(git log --graph --pretty=format:'' ${1+"$@"} |
    awk '{ print length }' |
    sort -n -r -u |
    head -n 1)

# Calculate short hash width
hashWidth=$(git rev-parse --short HEAD | awk '{ print length }')

# Configure column widths
authorWidth="${GIT_GRAPH_AUTHOR_WIDTH:-12}"
dateWidth="${GIT_GRAPH_DATE_WIDTH:-12}"

# Options
dateFormat="${GIT_GRAPH_DATE_FORMAT:-relative}"

# Setup format strings
config="%w(${width})%C(auto)"
hash="%>|($((graphWidth + hashWidth)))%C(blue)%h%C(auto)"
decorate="%D"
message="%<|($((width - authorWidth - dateWidth - 2)),trunc)%s"
author="%C(blue)%<(${authorWidth},trunc)%an%C(auto)"
date="%C(green)%>|(${width},trunc)%ad%C(auto)"

# Run git log with the calculated format
LANG=C.UTF-8 git log --graph --color \
    --pretty=format:"${config}${hash} ${decorate}  ${message} ${author} ${date}" \
    --date="${dateFormat}" \
    ${1+"$@"}

printf '\n'
