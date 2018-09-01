# aliases for bootstrapping docker workspace

alias jn-workspace='/data/gitlab/home/ansible/workspace.sh'
alias jn-workspace-minimal='/data/gitlab/home/ansible/workspace.sh --tags=workspace.bootstrap.minimal'
alias jn-workspace-enhance='/data/gitlab/home/ansible/workspace.sh -e "workspace_enhance_enabled=True"'
alias jn-workspace-developmment='/data/gitlab/home/ansible/workspace.sh development'

alias jn-env='cd; . .bashrc'
