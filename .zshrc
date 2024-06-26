# Set up the prompt

autoload -Uz promptinit
promptinit

autoload -U incremental-complete-word
zle -N incremental-complete-word
autoload -U insert-files
zle -N insert-files
autoload -U predict-on
zle -N predict-on

source ~/.zsh/git-prompt/zshrc.sh
if [ "$EUID" = "0" ]; then
  PROMPT=$'%{\e[1;31m%}[%{\e[1;33m%}azhi %{\e[1;33m%}%~%{\e[1;31m%}]%{\e[0m%}$(git_super_status)%{\e[1;33m%}#%{\e[0m%} '
  RPROMPT=$'%{\e[1;31m%}[%{\e[1;33m%}%T%{\e[1;31m%}]%{\e[0m%}'
else
  PROMPT=$'%{\e[1;32m%}[%{\e[1;33m%}azhi %{\e[1;33m%}%~%{\e[1;32m%}]%{\e[0m%}$(git_super_status)%{\e[1;33m%}>%{\e[0m%} '
  RPROMPT=$'%{\e[1;32m%}[%{\e[1;33m%}%T%{\e[1;32m%}]%{\e[0m%}'
fi

autoload -Uz add-zsh-hook

function xterm_title_precmd () {
  print -Pn '\e]2;%n@%m\a'
}

if [[ "$TERM" == (screen*|xterm*|rxvt*) ]]; then
  add-zsh-hook -Uz precmd xterm_title_precmd
fi

EDITOR=nvim
export EDITOR

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

case $TERM in (xterm*|rxvt)
  precmd () { print -Pn "\e]0;%n@%m: %~\a" }
  preexec () { print -Pn "\e]0;%n@%m: $1\a" }
  ;;
esac

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY HIST_SAVE_NO_DUPS HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS APPEND_HISTORY

setopt CORRECT MENUCOMPLETE ALL_EXPORT

setopt histignorealldups sharehistory

# Use autocd
setopt autocd

# Extended opts
setopt extendedglob
setopt extended_glob

# Expands {abc}file to afile bfile cfile, etc.
setopt brace_ccl

# Searches =name in PATH
setopt equals

# Dont require a leading dot for matching "hidden" files
setopt glob_dots

# Enable multiple redirections
setopt multios

# Report status of bg jobs immediately
setopt notify

# Report status of bg jobs if exiting
setopt check_jobs

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# zstyle ':completion:*' menu select=long
zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*' old-menu false
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' add-space true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


# use terminfo instead of zkdb
# uncomment zkdb if any issues with key bindings arise
#
# autoload zkbd
# [[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
# [[ ! -f ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE} ]] && zkbd
# source  ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}

typeset -g -A key

key[F1]="${terminfo[kf1]}"
key[F2]="${terminfo[kf2]}"
key[F3]="${terminfo[kf3]}"
key[F4]="${terminfo[kf4]}"
key[F5]="${terminfo[kf5]}"
key[F6]="${terminfo[kf6]}"
key[F7]="${terminfo[kf7]}"
key[F8]="${terminfo[kf8]}"
key[F9]="${terminfo[kf9]}"
key[F10]="${terminfo[kf10]}"
key[F11]="${terminfo[kf11]}"
key[F12]="${terminfo[kf12]}"
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

#setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     history-search-backward
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   history-search-forward
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# shift-tab : go backward in menu (invert of tab)
insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey '^[1' insert-sudo

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# aliases
alias ls='ls --color=auto'
alias ll='ls -lh --color=auto'
alias grep='grep --colour=auto'

alias be='bundle exec'
alias ber='bundle exec rake'

alias gst='git status'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gss='git stash save'
alias gdh='git diff HEAD'

source ~/.zsh/dotenv.sh
source ~/.zsh/kube-exec-wrappers.sh
source ~/.zsh/env.sh

. $HOME/.asdf/asdf.sh
fpath=($HOME/.asdf/completions $fpath)

# NPM global packages in HOME
NPM_PACKAGES="$HOME/.npm-packages"
PATH="$NPM_PACKAGES/bin:$PATH"
# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH  # delete if you already modified MANPATH elsewhere in your configuration
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
