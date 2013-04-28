#!/bin/bash

echo "Starting god ..."

god -c ./production.conf.rb -l ../logs/god.log --log-level info

# In case you tell express listen on port 80, please use comment out above line and use below one 
# sudo env PATH=$PATH god -c ./production.conf.rb -l ../logs/god.log --log-level info

echo ""
echo "god started!"
