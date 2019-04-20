# aliases for bootstrapping docker workspace

# TODO: switch over to Makefile approach
# Demonstrates use of ansible site, environment and tags
alias jn-workspace='/data/gitlab/home/ansible/workspace.sh'
alias jn-workspace-minimal='/data/gitlab/home/ansible/workspace.sh --tags=workspace.bootstrap.minimal'
alias jn-workspace-enhance='/data/gitlab/home/ansible/workspace.sh -e "workspace_enhance_enabled=True"'
alias jn-workspace-developmment='/data/gitlab/home/ansible/workspace.sh development'
# Replace above
alias jn-make-workspace='cd /data/gitlab/home/ansible && make workspace'
alias jn-make-workspace-minimal='cd /data/gitlab/home/ansible && make workspace-minimal'
alias jn-make-workspace-enhance='cd /data/gitlab/home/ansible && make workspace-enhance'
alias jn-make-workspace-developmment='cd /data/gitlab/home/ansible && make workspace-development'

# Loads bash environment
#alias jn-env='cd; . .bashrc'
alias jn-env='cd; . .bash_profile'
