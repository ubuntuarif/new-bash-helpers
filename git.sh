gitInstall(){
    printf 'y\n' | sudo apt-get install git git-core xclip
}

git config --global user.name "$SYSTEM_USER_FULL_NAME"
GIT_COMMITTER_NAME="$SYSTEM_USER_FULL_NAME"
GIT_AUTHOR_NAME="$SYSTEM_USER_FULL_NAME"
git config --global user.email "$SYSTEM_USER_EMAIL"
GIT_COMMITTER_EMAIL="$SYSTEM_USER_EMAIL"
GIT_AUTHOR_EMAIL="$SYSTEM_USER_EMAIL"

sshOperationsSudo() {
    funcName=$(getFunctionName)
    checkIfSudo $funcName
    if [ "${?}" = "0" ] ; then
        return
    fi;
    ssh_agent_verify
    ssh_agent_add_root
    github_keyscan_sudo
    bitbucket_keyscan_sudo
    github_auth
    bitbucket_auth
}

sshOperationsNonSudo() {
    funcName=$(getFunctionName)
    checkIfNotSudo $funcName
    if [ "${?}" = "0" ] ; then
        return
    fi;
    ssh_agent_verify
    ssh_agent_add
    github_keyscan_non_sudo
    bitbucket_keyscan_non_sudo
    github_auth
    bitbucket_auth
}


gitResetHard() {
    branchName="$(git rev-parse --abbrev-ref HEAD)"
    git reset --hard origin/"${branchName}"
}

gitRebase() {
    funcName=$(getFunctionName)
    if [ -z "$1" ]; then
        echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
        return $1
    fi;
    printf 'yes\n' | git fetch --all
    git rebase origin/$1
}

gitCheckout() {
    funcName=$(getFunctionName)
    if [ -z "$1" ]; then
        echo "null value not allowed as first parameter for method: \"${funcName}\"! You must pass the required parameter(s)."
        return $1
    fi;
    printf 'yes\n' | git fetch --all
    git checkout $1
    gitResetHard
}

alias git_install=gitInstall
alias get_ssh='cat ~/.ssh/id_rsa.pub | xclip -sel clip'
alias git_a='git add '
alias git_b='git_f && git rev-parse --abbrev-ref HEAD'
alias git_c=gitCheckout
alias git_cc='git commit -m "Rebased and resolved conflicts after rebasing from base branch."'
alias git_co='git commit -m '
alias git_f='printf "yes\n" | git fetch --all'
alias git_l='git_f && git log'
alias git_p='git push origin HEAD -f'
alias git_r=gitRebase
alias git_rd='gitRebase develop'
alias git_rc='git rebase --continue'
alias git_remove_last_commit='git reset --hard HEAD^'
alias git_rh='git_f && gitResetHard'
alias git_rl='git_f && git reflog'
alias git_s='git_f && git status'
alias git_set_name="git config --global user.name '$SYSTEM_USER_FULL_NAME'"
alias git_set_email="git config --global user.email '$SYSTEM_USER_EMAIL'"
alias github_auth='printf "yes\n" | ssh -T git@github.com'
alias github_keyscan_non_sudo="ssh-keyscan -t rsa github.com >> $SYSTEM_ROOT_FOLDER/.ssh/known_hosts"
alias github_keyscan_sudo='ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts'
alias gpg_config='git config --global gpg.program gpg2'
alias gpg_export='gpg --armor --export'
alias gpg_gen='gpg --gen-key'
alias gpg_list='gpg --list-secret-keys --keyid-format LONG'
alias gpg_sign='git config --global user.signingkey'
alias ssh_agent_add='ssh-add ~/.ssh/id_rsa'
alias ssh_agent_add_root='ssh-add /root/.ssh/id_rsa'
alias ssh_agent_verify='eval "$(ssh-agent -s)"'
alias ssh_keygen='ssh-keygen -t rsa -b 4096 -C "$SYSTEM_USER_EMAIL"'
alias ssh_non_sudo_setup=sshOperationsNonSudo
alias ssh_sudo_setup=sshOperationsSudo
alias bitbucket_auth='printf "yes\n" | ssh -T git@bitbucket.com'
alias bitbucket_keyscan_non_sudo="ssh-keyscan -t rsa bitbucket.com >> $SYSTEM_ROOT_FOLDER/.ssh/known_hosts"
alias bitbucket_keyscan_sudo='ssh-keyscan -t rsa bitbucket.com >> /root/.ssh/known_hosts'
