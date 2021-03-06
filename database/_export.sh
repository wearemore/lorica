#!/bin/bash
SOURCEDIR="$( cd "$( dirname "$0" )" && pwd )"

if [ $# -gt 1 ]
then
  DESTINATION_SQL=$1
  old=$2
  new=${3:-ROOTURL} # https://stackoverflow.com/a/2013589/1109380

  cd "$SOURCEDIR"

  # https://stackoverflow.com/a/25518345/1109380
  if [ -f /.dockerenv ]; then
    wp="wp"
  else
    # Use wp-cli from local composer
    wp="$SOURCEDIR/../vendor/wp-cli/wp-cli/bin/wp"
  fi

  echo "Using $wp:"
  "$wp" cli version

  echo ""
  echo "Replacing $old to $new in database"
  "$wp" search-replace $old $new --all-tables --report-changed-only

  echo ""
  echo "Cleaning up"
  "$wp" db query < cleanup.sql

  echo ""
  echo "Exporting database to $DESTINATION_SQL"
  "$wp" db export "$DESTINATION_SQL"

  echo ""
  echo "Add newlines in $DESTINATION_SQL"
  sed -i 's$),($),\
($g' "$DESTINATION_SQL"

  if [ -x "$(command -v fromdos)" ]
  then
    echo ""
    echo "Convert line endings in $DESTINATION_SQL"
    fromdos "$(cygpath -w "$SOURCEDIR")\\$DESTINATION_SQL"
  fi

  echo ""
  echo "Restoring $new to $old in database"
  "$wp" search-replace $new $old --all-tables --report-changed-only
else
  echo "Expected at least two parameters";
fi

echo ""
read -p "Press ENTER to exit..."
