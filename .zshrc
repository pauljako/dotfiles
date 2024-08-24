# My .zshrc the core for everything
#
#
# Configurations:
# 
## The Oh-my-posh theme to use.
## Possible values: basic, basic-nerd
#
OMP_THEME="basic"
#
## The max size (in lines) of the .zsh_history file
## Default: 5000
#
HISTSIZE=5000
#
# Code:
#
#
# Detect Device Arch
arch="$(uname -m | tr '[:upper:]' '[:lower:]')"

case "${arch}" in
  x86_64) arch="amd64" ;;
  armv*) arch="arm" ;;
  arm64) arch="arm64" ;;
  aarch64) arch="arm64" ;;
  i686) arch="386" ;;
esac

if [ "${arch}" = "arm64" ] && [ "$(getconf LONG_BIT)" -eq 32 ]; then
  arch=arm
fi
#
# Detect Device Platform
platform="$(uname -s | awk '{print tolower($0)}')"

case "${platform}" in
  linux) platform="linux" ;;
  darwin) platform="darwin" ;;
esac
#
# Set the OMP Path and create the directory
OMP_PATH="$HOME/.config/oh-my-posh"
[ ! -d $OMP_PATH ] && mkdir -p "$(dirname $OMP_PATH)"
#
# Set the path to the OMP Theme
OMP_THEME_PATH="$OMP_PATH/$OMP_THEME.toml"
#
# Set the OMP target Platform
OMP_TARGET="$platform-$arch"
#
# Set the path to the OMP Executeable
OMP_EXE="$OMP_PATH/posh-$OMP_TARGET"
#
# Download OMP if it does not exist
if [ ! -f $OMP_EXE ]; then
	echo "Downloading Oh My Posh for $OMP_TARGET"
	curl -s -L -o $OMP_EXE "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-$OMP_TARGET"
	chmod +x $OMP_EXE
fi
#
# Alias OMP
alias oh-my-posh=$OMP_EXE
#
# Initialize OMP
eval "$(oh-my-posh init zsh --config $OMP_THEME_PATH)"
#
# Get and download zinit
ZINIT_HOME="$HOME/.config/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
#
# Initialize zinit
source "${ZINIT_HOME}/zinit.zsh"
#
# Command Syntax Highlighting
zinit light zsh-users/zsh-syntax-highlighting
#
# Command Completions
zinit light zsh-users/zsh-completions
#
# Inline Command Suggestions based on history
zinit light zsh-users/zsh-autosuggestions
#
# Initialize TheF*ck if it exists
if command -v thefuck &> /dev/null
then
    eval "$(thefuck --alias)"
fi
#
# Colored ls
alias ls="ls --color=auto"
#
# ls like colored completions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
#
# Alias please to run0, doas, sudo or su
if command -v run0 &> /dev/null
then
    alias please="run0"
elif command -v doas &> /dev/null
then
    alias please="doas"
elif command -v sudo &> /dev/null
then
    alias please="sudo"
elif command -v su &> /dev/null
then
    alias please="su -c "
fi
#
# Alias la to ls -la
alias la="ls -la"
#
# Enable emacs keybindings
bindkey -e
#
# The file the History is written to
HISTFILE=~/.zsh_history
#
# The maximum History Size
SAVEHIST=$HISTSIZE
#
# Erease duplicates
HISTDUP=erase
#
# Share History between Sessions
setopt appendhistory
setopt sharehistory
#
# Ignore when Space is in front
setopt hist_ignore_space
#
# Ingore Duplicates
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
#
# Load the zsh completion system
autoload -U compinit && compinit
