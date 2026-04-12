#!/bin/sh
set -eu

# Calculate viewport width
terminalWidth=$(tput cols 2>/dev/null || printf '80')
width=$((terminalWidth - 1))

# Calculate maximum width of the graph
graphWidth=$(git log --graph --pretty=format:'' ${1+"$@"} |
    awk '{ print length }' |
    sort -n -r -u |
    head -n 1)

# Calculate short hash width
hashWidth=$(git rev-parse --short HEAD | awk '{ print length }')

# Configure column widths
authorWidth=12
dateWidth=12

# Setup format strings
config="%w(${width})%C(auto)"
hash="%>|($((graphWidth + hashWidth)))%C(blue)%h%C(auto)"
decorate="%D"
message="%<|($((width - authorWidth - dateWidth - 2)),trunc)%s"
author="%C(blue)%<(${authorWidth},trunc)%an%C(auto)"
date="%C(green)%>|(${width},trunc)%ar%C(auto)"

# Run git log with the calculated format
LANG=C.UTF-8 git log --graph --color \
    --pretty=format:"${config}${hash} ${decorate}  ${message} ${author} ${date}" \
    ${1+"$@"}

printf '\n'
