#!/bin/bash -e
#
# @author holman
#
# Shortcut script to deploy Ocsigen web server and compile Sass

PROJECT_NAME=my-site
CMDPIPE=/var/run/my-site-cmd

# dev|prod
ENV=$1

usage() {
  echo "Usage ./deploy.sh (dev|prod)"
  exit
}

[[ $# -lt 1 || ( $ENV != 'dev' && $ENV != 'prod' ) ]] && usage


# Pull the latest files
pull_latest() {
  if [[ $ENV == 'dev' ]]; then
    git pull --no-rebase
  elif [[ $ENV == 'prod' ]]; then
    # Don't allow uncommited changes in prod
    git pull
  fi

  # Compile the Sass files
  compass compile -c assets/compass_config.rb --force

  make
}

# Load RVM into a shell session *as a function*
source '/home/holman/.rvm/scripts/rvm'

# Go into script directory (which is the repo directory)
cd "$(dirname "$0")"

if [ $1 == 'dev' ]; then
  pull_latest

  make test.byte
elif [ $1 == 'prod' ]; then
  pull_latest

  sudo make install

  # We run this to figure out if the server is already running
  RC=0
  pgrep ocsigenserver > /dev/null || RC=1

  if [ $RC -ne 0 ]; then
    echo -e "\nStarting Ocsigen server..."
    nohup \
      sudo PATH=$PATH CAML_LD_LIBRARY_PATH=$CAML_LD_LIBRARY_PATH make run.byte \
      > /tmp/${PROJECT_NAME}.out >& /tmp/${PROJECT_NAME}.err &
  else
    echo -e "\nRestarting Ocsigen server..."
    echo reload > $CMDPIPE
  fi
else
  usage
fi
