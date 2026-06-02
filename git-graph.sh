#!/bin/sh
set -eu
IFS=$(printf ' \n\t')

args=${1+"$@"}

# Compatibility check
command -v git >/dev/null || ( printf 'git not found\n' >&2 && exit 1 )
command -v awk >/dev/null || ( printf 'awk not found\n' >&2 && exit 1 )
command -v sort >/dev/null || ( printf 'sort not found\n' >&2 && exit 1 )
command -v head >/dev/null || ( printf 'head not found\n' >&2 && exit 1 )

# Context check
git rev-parse >/dev/null 2>&1 || ( printf 'not a git repository\n' >&2 && exit 1 )

# Calculate viewport width
terminalWidth=$(tput cols 2>/dev/null || printf '80')
width="${GIT_GRAPH_WIDTH:-$((terminalWidth - 1))}"

# Calculate maximum width of the graph
graphWidth=$(git log --graph --max-count=500 --pretty=format:'' ${args} |
    awk '{ print length }' |
    sort -n -r -u |
    head -n 1)

# Threshold for removing left indentation
# Prevents breaking columns layout when using '--stat' or similar options
graphWidthThreshold="${GIT_GRAPH_GRAPH_WIDTH_THRESHOLD:-30}"
if [ ${graphWidthThreshold} -lt ${graphWidth} ]; then
    graphWidth='0'
fi

# Calculate short hash width
hashWidth=$(git rev-parse --short HEAD | awk '{ print length }')

# Configure column widths
authorWidth="${GIT_GRAPH_AUTHOR_WIDTH:-12}"
dateWidth="${GIT_GRAPH_DATE_WIDTH:-12}"

# Options
dateFormat="${GIT_GRAPH_DATE_FORMAT:-relative}"

# Setup format strings
hash="%>|($((graphWidth + hashWidth)))%C(blue)%h%C(auto)"
decorate="% D"
message="%<|($((width - authorWidth - dateWidth - 2)),trunc)% s"
author="%C(blue)%<(${authorWidth},trunc)% an%C(auto)"
date="%C(green)%>|(${width},trunc)% ad%C(auto)"

format="${hash}${decorate}${message}${author}${date}"

# Add '\n' at the end of the line when using options like: --stat, --patch, etc.
multiline=false
for arg in ${args}; do
    case "${arg}" in
        '--compact-summary'|\
        '--name-only'|\
        '--name-status'|\
        '--numstat'|\
        '--patch'|'-p'|'-u'|\
        '--shortstat'|\
        '--stat'|\
        '--summary')
            multiline=true
            break ;;
        *)
            continue ;;
    esac
done

if ${multiline}; then
    format="${format}%n"
fi

# Run git log with the calculated format
LANG=C.UTF-8 git log --graph --color \
    --pretty=format:"${format}" \
    --date="${dateFormat}" \
    ${args}

printf '\n'
