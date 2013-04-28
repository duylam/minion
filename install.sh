#!/bin/bash

COFFEE_LINK="$HOME/bin/coffee"

echo "*** 1. Installing node modules"
npm install -d

echo ""
echo "*** 2. Making soft links (symbolic link) to $COFFEE_LINK"
if [ ! -f $COFFEE_LINK ]; then
  ln -s `pwd`/node_modules/coffee-script/bin/coffee $COFFEE_LINK
else
  echo "WARNING: File $COFFEE_LINK existed, do nothing"
fi

echo ""
echo "*** Finished! ***"
