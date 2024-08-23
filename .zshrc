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
# Get and download the correct OMP
correct_omp="$HOME/.config/oh-my-posh/posh-$platform-$arch"
if [ ! -f "$correct_omp" ]; then
	echo "Downloading Oh My Posh for $platform-$arch"
	curl -s -L -o "$correct_omp" "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-$platform-$arch"
	chmod +x "$correct_omp"
fi
alias oh-my-posh="$correct_omp"
#
# Initialize OMP
eval "$(oh-my-posh init zsh)"
