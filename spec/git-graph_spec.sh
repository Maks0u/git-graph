export GIT_GRAPH_WIDTH=80

Describe 'git-graph.sh'
    noargs() { ./git-graph.sh; }
    It 'Works with no args'
        When call noargs
        Dump
        The status should be success
        The first word of first line should equal '*'
    End

    branch() { ./git-graph.sh 'main'; }
    It 'Can select a branch'
        When call branch
        Dump
        The status should be success
        The first word of first line should equal '*'
    End

    nospaces() { ./git-graph.sh --since='6months'; }
    It 'Can use options with no spaces'
        When call nospaces
        Dump
        The status should be success
        The first word of first line should equal '*'
    End

    spaces() { ./git-graph.sh --since='6 months'; }
    It 'Can use options with spaces'
        When call spaces
        Dump
        The status should be success
        The first word of first line should equal '*'
    End

    paths() { ./git-graph.sh -- README.md git-graph.plugin.zsh; }
    It 'Can provide paths'
        When call paths
        Dump
        The status should be success
        The first word of first line should equal '*'
    End

    multiline() { ./git-graph.sh -3 --stat; }
    It 'Can use multiline options'
        When call multiline
        Dump
        The status should be success
        The first word of first line should equal '*'
    End

    options() { ./git-graph.sh --author=Maks0u -2 -- README.md git-graph.plugin.zsh; }
    It 'Can combine a lot of options'
        When call options
        Dump
        The status should be success
        The first word of first line should equal '*'
    End
End
