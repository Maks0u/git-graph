PLUGIN_PATH="$(dirname "${0}")"

# git log graph with custom columns
git-graph() {
    "${PLUGIN_PATH}/git-graph.sh" "${@}"
}
# Use git-log completions
compdef _git git-graph=git-log
# Aliases
alias gg='git-graph'
alias gga='git-graph --all'
alias ggs='git-graph --all --max-count=20 | cat'

# Visualize diverging branches
git-graph-merge-base() {
    if [[ $# -eq 0 ]]; then
        set -- "${GIT_GRAPH_DEFAULT_BRANCH:-main}" HEAD
    elif [[ $# -eq 1 ]]; then
        set -- "${1}" HEAD
    fi
    local base
    base="$(git merge-base --octopus "${@}")"
    "${PLUGIN_PATH}/git-graph.sh" "${@}" "${base}"^!
}
# Use git-log completions
compdef _git git-graph-merge-base=git-log
# Aliases
alias ggb='git-graph-merge-base'
