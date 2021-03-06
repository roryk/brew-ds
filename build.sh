#!/usr/bin/env bash

# Install brew, use brew to install system files and then use R and python
# package managers to install their recommended packages/modules

install_brew () {
  /usr/bin/ruby -e "$(curl -fsSL "`
    `"https://raw.githubusercontent.com/Homebrew/install/master/install)"

  ## Make sure your PATH variable is as we expect
  echo "export PATH=/usr/local/bin:/usr/local/sbin:$PATH" > ~/.profile
  source ~/.profile

  ## Refresh your command index
  hash -r
}

## check internet connection
wget -q --tries=3 --timeout=5 --spider http://google.com
if [[ $? -eq 0 ]]; then
  echo "* Installing software"

  ## check to see if brew already exists, if it does skip installation
  command -v brew >/dev/null && echo "* brew exists, skipping" || install_brew

  # Install from Brewfile
  brew bundle 1>install.log

  # Install common R packages
  Rscript "install.packages(c('tidyverse', 'rmarkdown', 'shiny', 'mlr'), "`
  `"repos = 'https://cloud.r-project.org/')" 1>install.log

  # Install common python modules
  pip3 install -r requirements.txt 1>install.log

  echo "** Install complete"

else
  echo "* There is no internet connection, exiting."
fi