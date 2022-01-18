#!/bin/bash

UNIX_USER="ec2-user"
UNIX_USER_HOME="/home/ec2-user"
ENVIRONMENT_PATH="/home/ec2-user/environment"
UNIX_GROUP=$(id -g -n "$UNIX_USER")

# Apply security patches
OPERATING_SYSTEM=$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release | sed -e 's/^"//' -e 's/"$//')
if [ "$OPERATING_SYSTEM" == "amzn" ]; then
    yum -q -y update --security > /tmp/init-yum-update-security 2>&1 &
elif [ "$OPERATING_SYSTEM" == "ubuntu" ]; then
    unattended-upgrade &
fi

# add SSH key
install -g "$UNIX_GROUP" -o "$UNIX_USER" -m 755 -d "$UNIX_USER_HOME"/.ssh
cat <<'EOF' >> "$UNIX_USER_HOME"/.ssh/authorized_keys
# Important
# ---------
# The following public key is required by Cloud9 IDE
# Removing this key will make this EC2 instance inaccessible by the IDE
#
cert-authority ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDsr+QgCRe4yBewdOAhEipMTRBsUslDaboTOJrwWjKgbU2dXuCRnGIs8WtqGmyBs6CSjby7wRSUyUFeZzpcHrn0GUjmc6bn0fURI7/tGhrRGAwFEKKNRr3VWg53oFpCeAR0jtXm+7o3DbWMIGBSO1D+ZjqmExNxem3ujhvc0IJg2ZKCCnHHqDH8hy1mHKGeD4bJO3PSnWQLMhoO0CS8TQiR6Qo9AhLuCuDVZl9zntm+5ShHHszCZRFXVs8piCGbKm9o0D+q1zKxgh/ZFx+pYr33dEueIhMAx8lnfdOwkLoF4IdzCiEXT/OYDXnRw292kN/fsBBgXqSw5f8W2VQceF6uk7bPkzkPRCOBs9bVP7n3cZe3MKYOSnYGt2Iyp52YKegQaY/tyVlPgYnicSN3J12FsvVuJbSqzqQQOW2rXOxKGCK50KYO2na9J6wP8USfzVw0cnyqhDE6qV15Oyi+UbT2OvRnDnQTr/WHJQ0ZXSpIx5U1YE5FTTKB63pRZKxhNjVRAgjjVMLgyWF8UUAksjknPVrmEQFfHG9QriZueEM8uWeLb+1TAtmPvJYd6/VIR8L6UsSqX0ZQqGwYB9mgbaaBs1+Qt/VVyW3oiTemgejEzzMPv9Z7gsJMEttNgARMh9VXgPJV8tHu5vKncNPHkJiKCZnmmiWEyERvqaVS61F8MQ== f18841777c90431a90805562ce34425f@cloud9.amazon.com


#
# Add any additional keys below this line
#

EOF

# allow automatic shutdown
echo "$UNIX_USER    ALL=(ALL) NOPASSWD: /sbin/poweroff, /sbin/reboot, /sbin/shutdown" >> /etc/sudoers

ln -s /opt/c9 "$UNIX_USER_HOME"/.c9
chown -R "$UNIX_USER":"$UNIX_GROUP" "$UNIX_USER_HOME"/.c9 /opt/c9
install -g "$UNIX_GROUP" -o "$UNIX_USER" -m 755 -d "$ENVIRONMENT_PATH"

if [ "$ENVIRONMENT_PATH" == "/home/ec2-user/environment" ] && grep "alias python=python27" "$UNIX_USER_HOME"/.bashrc; then

    cat <<'EOF' > "$UNIX_USER_HOME"/.bashrc
# .bashrc

export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# load nvm
export NVM_DIR="$HOME/.nvm"
[ "$BASH_VERSION" ] && npm() {
    # hack: avoid slow npm sanity check in nvm
    if [ "$*" == "config get prefix" ]; then which node | sed "s/bin\/node//";
    else $(which npm) "$@"; fi
}
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
rvm_silence_path_mismatch_check_flag=1 # prevent rvm complaints that nvm is first in PATH
unset npm # end hack


# User specific aliases and functions
alias python=python27

# modifications needed only in interactive mode
if [ "$PS1" != "" ]; then
    # Set default editor for git
    git config --global core.editor nano

    # Turn on checkwinsize
    shopt -s checkwinsize

    # keep more history
    shopt -s histappend
    export HISTSIZE=100000
    export HISTFILESIZE=100000
    export PROMPT_COMMAND="history -a;"

    # Source for Git PS1 function
    if ! type -t __git_ps1 && [ -e "/usr/share/git-core/contrib/completion/git-prompt.sh" ]; then
        . /usr/share/git-core/contrib/completion/git-prompt.sh
    fi

    # Cloud9 default prompt
    _cloud9_prompt_user() {
        if [ "$C9_USER" = root ]; then
            echo "$USER"
        else
            echo "$C9_USER"
        fi
    }

    PS1='\[\033[01;32m\]$(_cloud9_prompt_user)\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " (%s)" 2>/dev/null) $ '
fi

EOF

    chown "$UNIX_USER":"$UNIX_GROUP" "$UNIX_USER_HOME"/.bashrc
fi

if [ "$ENVIRONMENT_PATH" == "/home/ec2-user/environment" ] && [ ! -f "$ENVIRONMENT_PATH"/README.md ]; then
    cat <<'EOF' >> "$ENVIRONMENT_PATH"/README.md
         ___        ______     ____ _                 _  ___
        / \ \      / / ___|   / ___| | ___  _   _  __| |/ _ \
       / _ \ \ /\ / /\___ \  | |   | |/ _ \| | | |/ _` | (_) |
      / ___ \ V  V /  ___) | | |___| | (_) | |_| | (_| |\__, |
     /_/   \_\_/\_/  |____/   \____|_|\___/ \__,_|\__,_|  /_/
 -----------------------------------------------------------------


Hi there! Welcome to AWS Cloud9!

To get started, create some files, play with the terminal,
or visit https://docs.aws.amazon.com/console/cloud9/ for our documentation.

Happy coding!

EOF

    chown "$UNIX_USER":"$UNIX_GROUP" "$UNIX_USER_HOME"/environment/README.md
fi

# Fix for permission error when trying to call `gem install`
chown "$UNIX_USER" -R /usr/local/rvm/gems

#This script is appended to another bash script, so it does not need a bash script file header.

UNIX_USER_HOME="/home/ec2-user"

C9_DIR=$UNIX_USER_HOME/.c9
CONFIG_FILE_PATH="$C9_DIR"/autoshutdown-configuration
VFS_CHECK_FILE_PATH="$C9_DIR"/stop-if-inactive.sh

echo "SHUTDOWN_TIMEOUT=900" > "$CONFIG_FILE_PATH"
chmod a+w "$CONFIG_FILE_PATH"

echo -e '#!/bin/bash
set -euo pipefail
CONFIG=$(cat '$CONFIG_FILE_PATH')
SHUTDOWN_TIMEOUT=${CONFIG#*=}
if ! [[ $SHUTDOWN_TIMEOUT =~ ^[0-9]*$ ]]; then
    echo "shutdown timeout is invalid"
    exit 1
fi
is_shutting_down() {
    is_shutting_down_ubuntu &> /dev/null || is_shutting_down_al1 &> /dev/null || is_shutting_down_al2 &> /dev/null
}
is_shutting_down_ubuntu() {
    local TIMEOUT
    TIMEOUT=$(busctl get-property org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.login1.Manager ScheduledShutdown)
    if [ "$?" -ne "0" ]; then
        return 1
    fi
    if [ "$(echo $TIMEOUT | awk "{print \$3}")" == "0" ]; then
        return 1
    else
        return 0
    fi
}
is_shutting_down_al1() {
    pgrep shutdown
}
is_shutting_down_al2() {
    local FILE
    FILE=/run/systemd/shutdown/scheduled
    if [[ -f "$FILE" ]]; then
        return 0
    else
        return 1
    fi
}
is_vfs_connected() {
    pgrep -f vfs-worker >/dev/null
}

if is_shutting_down; then
    if [[ ! $SHUTDOWN_TIMEOUT =~ ^[0-9]+$ ]] || is_vfs_connected; then
        sudo shutdown -c
    fi
else
    if [[ $SHUTDOWN_TIMEOUT =~ ^[0-9]+$ ]] && ! is_vfs_connected; then
        sudo shutdown -h $SHUTDOWN_TIMEOUT
    fi
fi' > "$VFS_CHECK_FILE_PATH"

chmod +x "$VFS_CHECK_FILE_PATH"

echo "* * * * * root $VFS_CHECK_FILE_PATH" > /etc/cron.d/c9-automatic-shutdown
