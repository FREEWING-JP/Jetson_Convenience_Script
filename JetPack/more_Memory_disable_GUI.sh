# How can I detect if the shell is controlled from SSH ?
# https://unix.stackexchange.com/questions/9605/how-can-i-detect-if-the-shell-is-controlled-from-ssh
SESSION_TYPE=
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh
# many other tests omitted
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE=remote/ssh;;
  esac
fi

free -h

echo $SESSION_TYPE
if [ -n "$SESSION_TYPE" ]; then
  systemctl get-default | grep graphical.target
  if [ $? -eq 0 ]; then
    sudo systemctl set-default multi-user.target
    sudo systemctl isolate multi-user
  fi
fi

free -h

