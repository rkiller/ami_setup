#!/usr/bin/env bash
set -xe
echo "I am: `whoami`"

if [ -z "$NODE_VERSION" ]; then NODE_VERSION='16'; fi

EXISTING_VERSION=`node --version`
echo "Node Version $NODE_VERSION set in config..."

# If yarn is not detected, install it.
if which yarn; then
  echo "Skipping installation of yarn -- yarn already installed."
  echo "yarn --version: `yarn --version`"
else
  echo "which yarn: `which yarn`"
  echo "Yarn is not installed and accessible."
  echo "Installing Node v$NODE_VERSION.x ..."

  curl -sL https://rpm.nodesource.com/setup_$NODE_VERSION.x | sudo bash -
  sudo yum install -y nodejs
  sudo yum -y install gcc-c++ make

  node --version
  echo "... and finished installing Node v$NODE_VERSION"

  echo "Installing yarn..."
        
  curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
  sudo yum -y install yarn

  yarn --version

  echo "... and finished installing yarn."

  # yarn install
  echo "Running yarn install."
  sudo yarn install --check-files
  
  if [ ! -f ./bin/yarn ]; then
    echo "Creating SymLink"
    ln -s $(which yarn) ./bin/yarn
  fi
fi