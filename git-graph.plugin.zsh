PLUGIN_PATH="$(dirname ${0})"

# git log graph with custom columns
git-graph() {
    "${PLUGIN_PATH}/git-graph.sh" "${@}"
}
# Use git-log completions
compdef _git git-graph=git-log
# Aliases
alias gg='git-graph'
alias ggs='git-graph --all --max-count=20 | cat'

# Visualize diverging branches
git-graph-merge-base() {
    local base="$(git merge-base "${@}")"
    "${PLUGIN_PATH}/git-graph.sh" "${@}" "${base}"^!
}
# Use git-log completions
compdef _git git-graph-merge-base=git-log
# Aliases
alias ggb='git-graph-merge-base'
