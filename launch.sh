#!/bin/bash
#
# @author holman
#
# Shortcut script to launch Ocsigen web server and compile Sass

PROJECT_NAME=my-site
CMDPIPE=/var/run/my-site-cmd

usage() {
  echo "Usage ./launch.sh (dev|prod)"
  exit
}

wrong_dir() {
  echo "Error: run from project root dir"
  exit
}

if [ $# -lt 1 ]; then usage; fi

# Compile the Sass files
compass compile -c static/compass/config.rb --force

# Compile the Eliom files first, then launch server
make

if [ $1 == 'dev' ]; then
  make test.byte
elif [ $1 == 'prod' ]; then
  sudo make install

  # We run this to figure out if the server is already running
  pgrep ocsigenserver > /dev/null

  if [ $? -ne 0 ]; then
    echo -e "\nLaunching Ocsigen server..."
    nohup \
      sudo PATH=$PATH CAML_LD_LIBRARY_PATH=$CAML_LD_LIBRARY_PATH make run.byte \
      > /tmp/${PROJECT_NAME}.out >& /tmp/${PROJECT_NAME}.err &
  else
    echo -e "\nRestarting Ocsigen server..."
    echo restart > $CMDPIPE
  fi
else
  echo "Usage ./launch.sh (dev|prod)"
fi
