# Setup packages for ubuntu 20.04
if [ $(lsb_release -d | grep -c "Ubuntu") = 1 ]; then
  if [ $(dpkg -l | grep -c build-essential) = 0 ]; then
    sudo apt-get update
    sudo apt-get install -y build-essential python3-venv vim git zsh xclip tree
  fi
  [ "$SHELL" != "/bin/zsh" ] && sudo chsh -s /bin/zsh $USER
fi

sudo -E apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo -E apt-add-repository https://cli.github.com/packages
sudo -E apt update
sudo -E apt install gh
