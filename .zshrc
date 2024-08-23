# My .zshrc the core for everything
#
# Colored ls
alias ls=ls --color=auto
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
eval "$(oh-my-posh init zsh)"
#
# Get and download zinit
ZINIT_HOME="$HOME/.config/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
# Initialize zinit
source "${ZINIT_HOME}/zinit.zsh"
