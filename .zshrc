echo .zshrc started
# ~/.zshrc file for zsh interactive shells.
# see /usr/share/doc/zsh/examples/zshrc for examples
setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS='_-/' # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=2000000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
#setopt hist_ignore_space      # ignore commands that start with space
#setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
# alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

configure_prompt() {
    prompt_symbol=㉿
    # Skull emoji for root terminal
    [ "$EUID" -eq 0 ] && prompt_symbol=💀
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            # Right-side prompt with exit codes and background processes
            RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
        backtrack)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
    esac
    unset prompt_symbol
}

# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=oneline
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    configure_prompt

    # enable syntax-highlighting
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown-token]=underline
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[path]=bold
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    fi
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%(#.#.$) '
fi
unset color_prompt force_color_prompt

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac

precmd() {
    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# some more ls aliases
alias ll='ls -lA'
alias la='ls -Al'
alias l='ls -CF'

# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

# -------- Zsh command logging (two files; hook-safe) --------
: ${CMDLOG_START_FILE:="$HOME/.cmdlog"}
: ${CMDLOG_SUMMARY_FILE:="$HOME/.cmdlog.summary"}

# Data stores
typeset -A _cmdlog_start_epoch _cmdlog_start_pretty _cmdlog_cmd _cmdlog_pwd
typeset -a _cmdlog_id_stack

# hi-res epoch
_cmdlog_now_epoch() {
  if [[ -n ${EPOCHREALTIME-} ]]; then
    print -r -- "$EPOCHREALTIME"
  else
    date +%s.%N 2>/dev/null || date +%s
  fi
}

# human-readable wall time (no timezone)
_cmdlog_now_pretty() {
  date +"%Y-%m-%d %H:%M:%S"
}

# duration as seconds.millis (e.g., 12.312)
_cmdlog_fmt_secs_ms() {
  local start="$1" end="$2"
  awk -v s="$start" -v e="$end" 'BEGIN{
    d = e - s; if (d < 0) d = 0;
    printf "%.3f", d
  }'
}

_cmdlog_preexec() {
  local cmd="$1"
  local id start_epoch start_pretty

  start_epoch=$(_cmdlog_now_epoch)
  start_pretty=$(_cmdlog_now_pretty)
  id="${start_epoch}-${RANDOM}-${$}"

  _cmdlog_start_epoch[$id]="$start_epoch"
  _cmdlog_start_pretty[$id]="$start_pretty"
  _cmdlog_cmd[$id]="$cmd"
  _cmdlog_pwd[$id]="$PWD"

  _cmdlog_id_stack+="$id"

  # FILE 1: write START immediately (survives crashes)
  # Example: 2025-11-12 16:02:17 /home/kali $ sleep 100
  print -r -- "${start_pretty} ${_cmdlog_pwd[$id]} \$ ${cmd}" >> "$CMDLOG_START_FILE"
}

_cmdlog_precmd() {
  local exit_status=$?
  (( ${#_cmdlog_id_stack[@]} == 0 )) && return

  local id="${_cmdlog_id_stack[-1]}"
  unset '_cmdlog_id_stack[-1]'

  [[ -z ${_cmdlog_start_epoch[$id]-} ]] && return

  local end_epoch="$(_cmdlog_now_epoch)"
  local start_epoch="${_cmdlog_start_epoch[$id]}"
  local start_pretty="${_cmdlog_start_pretty[$id]}"
  local cmd="${_cmdlog_cmd[$id]}"
  local cwd_after="$PWD"
  local duration="$(_cmdlog_fmt_secs_ms "$start_epoch" "$end_epoch")"

  # FILE 2: summary, human-readable start, duration in seconds.ms, exit code, and command
  # Example: start=2025-11-12 16:02:17 duration=2.134 exit=0 cwd=/home/kali $ ls -la
  print -r -- "start=${start_pretty} duration=${duration} exit=${exit_status} cwd=${cwd_after} \$ ${cmd}" >> "$CMDLOG_SUMMARY_FILE"

  # cleanup
  unset "_cmdlog_start_epoch[$id]" "_cmdlog_start_pretty[$id]" "_cmdlog_cmd[$id]" "_cmdlog_pwd[$id]"
}
# Use zsh's hook system so we don't get clobbered by other plugins/config
autoload -Uz add-zsh-hook
add-zsh-hook preexec _cmdlog_preexec
add-zsh-hook precmd  _cmdlog_precmd

# history behavior
setopt APPEND_HISTORY
#unalias history # disable kali's alias "history 0", you cannot use "history -a" then
alias his='builtin history | cut -c 8-'
alias h='builtin history 0'

# # share history: Up, Down: local. ^Up, ^Down: global shared.
# #
# # GPT:
# setopt share_history
# 
# up-line-or-local-history() {
#   zle set-local-history 1
#   zle up-line-or-history
#   zle set-local-history 0
# }
# zle -N up-line-or-local-history
# 
# down-line-or-local-history() {
#   zle set-local-history 1
#   zle down-line-or-history
#   zle set-local-history 0
# }
# zle -N down-line-or-local-history
# 
# # Adjust sequences using `cat` if needed:
# bindkey '^[[A'     up-line-or-local-history     # Up   -> local
# bindkey '^[[B'     down-line-or-local-history   # Down -> local
# 
# bindkey '^[[1;5A'  up-line-or-history           # Ctrl+Up   -> global
# bindkey '^[[1;5B'  down-line-or-history         # Ctrl+Down -> global
# 
# bindkey '^R' history-incremental-search-backward  # Ctrl+R -> global search
# 
#
# Source - https://superuser.com/questions/446594/separate-up-arrow-lookback-for-local-and-global-zsh-history/691603#691603
# Posted by lumbric, modified by community. See post 'Timeline' for change history
# Retrieved 2025-11-17, License - CC BY-SA 3.0

# Posted by Martin Geisler
# Retrieved 2025-11-17, License - CC BY-SA 4.0
# 
# function up-line-or-history() {
#     zle set-local-history 1
#     zle .up-line-or-history
#     zle set-local-history 0
# }
# 
# function down-line-or-history() {
#     zle set-local-history 1
#     zle .down-line-or-history
#     zle set-local-history 0
# }
# 
# # Overwrite existing {up,down}-line-or-history widgets with the functions above.
# zle -N up-line-or-history
# zle -N down-line-or-history
# 
# ###
# 
# # Stepping through local history.
# 
# # Stepping through global history.
# bindkey "^[[1;5A" .up-line-or-history                # Ctrl + Cursor Up
# bindkey "^[[1;5B" .down-line-or-history           # Ctrl + Cursor Down
# 

# 
# # local:
# bindkey "OA" up-line-or-local-history
# bindkey "OB" down-line-or-local-history
# up-line-or-local-history() {
#     zle set-local-history 1
#     zle up-line-or-history
#     zle set-local-history 0
# }
# zle -N up-line-or-local-history
# down-line-or-local-history() {
#     zle set-local-history 1
#     zle down-line-or-history
#     zle set-local-history 0
# }
# zle -N down-line-or-local-history
# 

# # global:
# bindkey "[1;5A" up-line-or-history    # [CTRL] + Cursor up
# bindkey "[1;5B" down-line-or-history  # [CTRL] + Cursor down
# 
# setopt SHARE_HISTORY
# # for CTRL-R, it will be global:
# # 	could not:
# # 	zle set-local-history 0
# # 	/home/kali/.zshrc:zle:390: widgets can only be called when ZLE is active
# 


# EOhistory behavior


# Helper script by @sechurity
# Create a log directory, a log file and start logging
if [ -z "$TMUX" ]  && [ -z "${UNDER_SCRIPT}" ]; then
    logdir=${HOME}/script-logs
    logfile=${logdir}/$(date +%F.%H-%M-%S).$$.log
    timingfile=${logdir}/$(date +%F.%H-%M-%S).$$.log.timing

    mkdir -p ${logdir}
    export UNDER_SCRIPT=${logfile}
    echo "[+] Starting script with output file $logfile"
    script -q -f ${logfile} --log-timing=$timingfile

    exit
fi

###########################
# tmux
###########################
_not_inside_tmux() { [[ -z "$TMUX" ]] }

ensure_tmux_is_running() {
  if _not_inside_tmux; then
    tat
  fi
}

ensure_tmux_is_running
##########################

mkcd ()
{
    mkdir -p -- "$1" &&
       cd -P -- "$1"
}

p() {
    if [ $# -eq 0 ]; then
        ps fauxwww | less
    else
        pgrep -fa "$@"
    fi
}

alias z='vim ~/.zshrc'
alias wd='source ~/bin/wd'
alias dig='echo "ℹ️  Hint: for multi-record queries use digq <domain>" >&2; /usr/bin/dig'
echo .zshrc finished

# Prepend categorized script directories to PATH for better organization.
#export PATH="$HOME/.local/bin/dotfiles:$PATH"
#export PATH="$HOME/.local/bin/hacking:$PATH"
#export PATH="$HOME/.local/bin/utils:$PATH"

# --- Machine-specific configurations ---
# Load hostname-specific configurations if they exist.
# This allows for customization per machine without polluting the main dotfiles.
if [[ -n "$HOST" ]]; then
    HOSTNAME_SHORT=$(echo "$HOST" | cut -d'.' -f1) # Get short hostname if FQDN
    [[ -f "$HOME/.zshrc.$HOSTNAME_SHORT" ]] && source "$HOME/.zshrc.$HOSTNAME_SHORT"
fi
# Example: Create a file ~/.zshrc.kali for kali-specific settings.
