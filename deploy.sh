#!/bin/bash -e
#
# @author holman
#
# Shortcut script to deploy Ocsigen web server and compile Sass

PROJECT_NAME=my-site
CMDPIPE=/var/run/my-site-cmd

usage() {
  echo "Usage ./deploy.sh (dev|prod)"
  exit
}

if [ $# -lt 1 ]; then usage; fi

# Compile the Sass files
compile_compass() {
  compass compile -c assets/compass_config.rb --force
}

# Go into script directory (which is the repo directory)
cd "$(dirname "$0")"

# Pull the latest files
git pull
git submodule init
git submodule foreach git pull origin master

compile_compass
make

if [ $1 == 'dev' ]; then
  make test.byte
elif [ $1 == 'prod' ]; then
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
