#!/bin/bash
#
# @author holman
#
# Shortcut script to launch Ocsigen web server and compile Sass

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

# Compile the Eliom files first, then run the launch make
make

if [ $1 == 'dev' ]; then
  make test.byte
elif [ $1 == 'prod' ]; then
  sudo make install

  echo -e "\nLaunching Ocsigen server..."
  nohup \
    sudo PATH=$PATH CAML_LD_LIBRARY_PATH=$CAML_LD_LIBRARY_PATH make run.byte \
    > /tmp/my-site.out >& /tmp/my-site.err &
else
  echo "Usage ./launch.sh (dev|prod)"
fi
