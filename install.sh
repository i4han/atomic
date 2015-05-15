#!/usr/bin/env bash
# curl -fsSL https://raw.github.com/action-io/autoparts/master/setup.rb | ruby

# for i in meteor mongodb
# do [[ `parts list` =~ $i ]] || parts install $i; done
NODE_MODULES=~/node_modules
[ -d $NODE_MODULES ] || mkdir $NODE_MODULES
[ -d ~/data ] || mkdir ~/data
for j in coffee-script underscore express stylus fs-extra fibers mongodb chokidar node-serialize request event-stream prompt jade ps-node MD5 googleapis log.io node-curl node-uber rimraf eco js2coffee path async readline nconf
do
    echo "Installing $j."
    npm install --prefix ~ $j
done
# for k in rmate; do gem install $k; done        
# if [ ! -e ../.bashrc ]; then
#    $NODE_MODULES/.bin/cake profile
#    . ~/.bashrc
# else
#    echo '.bashrc exists. Can not proceed.'
#    exit 0
# fi
# cake setup
# refresh
# logs
# logh