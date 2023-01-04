# tmux-presenter
Tmux presenter, sends commands from text files to tmux session

## Requirements

- tmux
- pgrep
- [gum](https://github.com/charmbracelet/gum)

## Enviroment Variables

| Name | Default| Description |
|-|-|-|
| TMUX_SESSION_NAME | presenter | Tmux session that you want to send the commands |
| TYPING_INTERVAL | .1 | Typing Interval between each character to be sent |
| COMMAND_INTERVAL | .5 | Interval between each commmand to be executed |
| WAIT_PROCESS | true | Wait for the completion of the current command and then go to the next one |

## Examples

Example waiting for ping to complete
```bash
./init.sh
Pause after each command ? no
Clear Screen after each command ? no
Press enter after each command ? yes
Select Presentation file 
  ping
```

Vim example
```bash
WAIT_PROCESS=false ./init.sh
Pause after each command ? no
Clear Screen after each command ? no
Press enter after each command ? no
Select Presentation file 
  vim
```

Wait 3 seconds between each command
```bash
COMMAND_INTERVAL=3 ./init.sh
Pause after each command ? no
Clear Screen after each command ? no
Press enter after each command ? yes
Select Presentation file 
  commands
```

Fast Typing
```bash
TYPING_INTERVAL=.03 ./init.sh
Pause after each command ? no
Clear Screen after each command ? no
Press enter after each command ? yes
Select Presentation file 
  commands
```

Docker, recommend to pause for each command
```bash
./init.sh
Pause after each command ? yes
Clear Screen after each command ? no
Press enter after each command ? yes
Select Presentation file 
  docker
```

Kind, recommend to pause for each command
```bash
./init.sh
Pause after each command ? yes
Clear Screen after each command ? no
Press enter after each command ? yes
Select Presentation file 
  kind
```
