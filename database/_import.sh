#!/bin/bash
SOURCEDIR="$( cd "$( dirname "$0" )" && pwd )"

if [ $# -gt 1 ]
then
  SOURCE_SQL=$1
  old=${3:-ROOTURL} # https://stackoverflow.com/a/2013589/1109380
  new=$2

  echo -n "Are you sure? [Y/n] "

  read addAuth
  if [ "$addAuth" == "y" ] || [ "$addAuth" == "Y" ] || [ "$addAuth" == "" ]; then
    cd "$SOURCEDIR"

    # https://stackoverflow.com/a/25518345/1109380
    if [ -f /.dockerenv ]; then
      wp="wp"
    else
      # Use wp-cli from local composer
      wp="$SOURCEDIR/../vendor/wp-cli/wp-cli/bin/wp"
    fi

    echo ""
    echo "Using $wp:"
    "$wp" cli version

    echo ""
    echo "Clear database"
    "$wp" db drop --yes
    "$wp" db reset --yes

    echo ""
    echo "Importing database from $SOURCE_SQL"
    "$wp" db import "$SOURCE_SQL"

    echo ""
    echo "Replacing $old to $new in database"
    "$wp" search-replace $old $new --all-tables --report-changed-only
  fi
else
  echo "Expected at least two parameters";
fi

echo ""
read -p "Press ENTER to exit..."
