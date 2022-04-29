#!/usr/bin/env bash
set -xe
echo "I am: `whoami`"

if [ -z "$NODE_VERSION" ]; then NODE_VERSION='16'; fi

EXISTING_VERSION=`node --version`
echo "Node Version $NODE_VERSION set in config..."

# If node or npm is not detected, install it.
#if [[ ${EXISTING_VERSION%.*.*} == "v$NODE_VERSION" ]]; then
#  echo "Skipping installation of node -- node version $NODE_VERSION already installed."
#  echo "node --version: `node --version`"
#else
  echo "Installing Node v$NODE_VERSION.x ..."
  # Download the Node setup script
  #curl --location https://rpm.nodesource.com/setup_$NODE_VERSION.x > ~/node_install.sh
  #          
  ## Confirm that it downloaded
  #file ~/node_install.sh
  #
 # # Clean yum cache
  #sudo yum -y remove nodejs npm
  #sudo rm -fr /var/cache/yum/*
  #sudo yum -y clean all
  #          
  ## Run the Node setup script
  ## When changing versions, make sure package in /var/cache/yum/x86_64/2018.03/nodesource/packages/ is deleted
  #sudo bash ~/node_install.sh
  #          
  ## Install nodejs
  #sudo yum -y install nodejs

  curl -sL https://rpm.nodesource.com/setup_$NODE_VERSION.x | sudo bash -
  sudo yum install -y nodejs
  sudo yum -y install gcc-c++ make

  node --version
  echo "... and finished installing Node v$NODE_VERSION"
#fi

# If yarn is not detected, install it.
if which yarn; then
  echo "Skipping installation of yarn -- yarn already installed."
  echo "yarn --version: `yarn --version`"
else
  echo "which yarn: `which yarn`"
  echo "Yarn is not installed and accessible."
  echo "Installing yarn..."
        
  # Consider that the EC2 instance is managed by AWS Elastic Beanstalk.
  # Changes made via SSH WILL BE LOST if the instance is replaced by auto-scaling.
  # QUESTION: Will this script be run on new instances that are created by auto-scaling?
  # QUESTION: Should installation be moved to a rake task?

  ## Download the yarn repo
  #sudo wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
  #      
  ## Confirm that it downloaded
  #file /etc/yum.repos.d/yarn.repo
  #      
  ## install yarn
  #sudo yum -y install yarn

  curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
  sudo yum -y install yarn

  yarn --version

  echo "... and finished installing yarn."
fi

# yarn install
echo "Running yarn install."
sudo yarn install --check-files

if [ ! -f ./bin/yarn ]; then
  echo "Creating SymLink"
  ln -s $(which yarn) ./bin/yarn
fi