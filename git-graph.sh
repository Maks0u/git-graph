#!/bin/bash
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

# Calculate viewport width
terminalWidth=$(tput cols)
width=$((${terminalWidth} - 1))

# Calculate maximum width of the graph
graphWidth=$(git log --graph --pretty=format:'' "${@}" |
    awk '{ print length }' |
    sort --numeric-sort --reverse --unique |
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
date="%C(green)%>|($width,trunc)%ar%C(auto)"

# Run git log with the calculated format
LANG=C.UTF-8 git log --graph --color \
    --pretty=format:"${config}${hash} ${decorate}  ${message} ${author} ${date}" \
    "${@}"
echo
