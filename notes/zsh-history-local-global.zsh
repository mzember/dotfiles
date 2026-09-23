# Parked from .zshrc on 20260924-001533: experimental per-arrow local/global zsh history.
# Reference only; not sourced. Restore into .zshrc if you want to pursue it.

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
