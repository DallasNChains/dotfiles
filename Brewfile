brew "jq"

tap "jandedobbeleer/oh-my-posh"
brew "jandedobbeleer/oh-my-posh/oh-my-posh"

# Assuming Homebrew handles this gracefully for you on Linux!
cask "font-jetbrains-mono-nerd-font"

if OS.mac?
  cask "rectangle"
  cask "wezterm"
else OS.linux?
  tap "wezterm/wezterm-linuxbrew"
  brew "wezterm"
end