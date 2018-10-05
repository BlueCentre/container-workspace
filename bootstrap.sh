# aliases for bootstrapping docker workspace

# Demonstrates use of ansible site, environment and tags
alias jn-workspace='/data/gitlab/home/ansible/workspace.sh'
alias jn-workspace-minimal='/data/gitlab/home/ansible/workspace.sh --tags=workspace.bootstrap.minimal'
alias jn-workspace-enhance='/data/gitlab/home/ansible/workspace.sh -e "workspace_enhance_enabled=True"'
alias jn-workspace-developmment='/data/gitlab/home/ansible/workspace.sh development'

# Loads bash environment
#alias jn-env='cd; . .bashrc'
alias jn-env='cd; . .bash_profile'
