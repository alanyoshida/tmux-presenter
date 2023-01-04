#!/bin/bash -
#===============================================================================
#
#          FILE: init.sh
#
#         USAGE: ./init.sh
#
#   DESCRIPTION: Tmux presenter, sends commands from text files to tmux session
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Alan Yoshida
#  ORGANIZATION:
#       CREATED: 03/01/2023 17:51
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

TMUX_SESSION_NAME=presenter
TYPING_INTERVAL=${TYPING_INTERVAL:=.1}
COMMAND_INTERVAL=${COMMAND_INTERVAL:=.5}
WAIT_PROCESS=${WAIT_PROCESS:=true}

# TODO Create session if does not exists
# tmux new-session -d -s presenter
# TODO list and select session
# tmux list-sessions
# tmux list-panes -F #{pane_pid} -t presenter

# Show if process is running from TMUX session, usefull for waiting a command to execute
# TMUX_PID=$(tmux list-panes -F '#{pane_pid}' -t $TMUX_SESSION_NAME)
# pgrep -P $TMUX_PID

# Reset the tmux session
tmux send-keys -Rt $TMUX_SESSION_NAME Enter

echo -e "Pause after each command ?"
ASK_FOR_INPUTS=$(gum choose "yes" "no")

echo -e "Clear Screen after each command ?"
CLEAR_SCREEN=$(gum choose "no" "yes")

echo -e "Press enter after each command ?"
EXECUTE=$(gum choose "yes" "no")

echo -e "Select Presentation file"
COMMANDS_FILE=$(gum choose $(ls presentations))

IFS=$'\n'
for line in $(cat presentations/$COMMANDS_FILE)
do
  echo -e "\n\e[1;32mCommand: $line\e[0m"
  if [[ $ASK_FOR_INPUTS == "yes" ]]; then
    read -p "Press enter to continue"
  fi
  if [[ $CLEAR_SCREEN == "yes" ]]; then
    tmux send-keys -Rt $TMUX_SESSION_NAME Enter
  fi
  # REGEX="^(Enter|Escape)$"
  # Reserved Words for tmux executing key press
  REGEX="^(([C,S,M]\-.?)|Up|Down|Left|Right|BSpace|BTab|DC|Delete|End|Escape|Enter|Home|F[1-9]{1,2}|IC|Insert|NPage|PageDown|PgDn|PPage|PageUp|PgUp|Space|Tab)$"
  if [[ $line =~ $REGEX ]]; then
    tmux send-keys -t $TMUX_SESSION_NAME $line
  else
    while read -n 1 char ; do
      if [[ $char = *" "* ]]; then
        tmux send-keys -t $TMUX_SESSION_NAME Space
      else
        tmux send-keys -t $TMUX_SESSION_NAME "$char"
      fi
      sleep $TYPING_INTERVAL
    done <<< "$line"
  fi
  if [[ $EXECUTE == "yes" ]]; then
    tmux send-keys -t $TMUX_SESSION_NAME Enter
  fi
  TMUX_PID=$(tmux list-panes -F '#{pane_pid}' -t $TMUX_SESSION_NAME)
  if [[ $WAIT_PROCESS == "true" ]]; then
    echo -n "Waiting ."
    while [ $(pgrep -P $TMUX_PID | wc | awk '{print $1}' ) != "0" ]
    do
      echo -n "."
      sleep .5
    done
  fi

 sleep $COMMAND_INTERVAL
done
