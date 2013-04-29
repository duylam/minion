Minion is a sample node.js web application to demonstrate how to use HTML5 websocket on node.js platform. Checkout the live minion at http://122.248.232.217:8080. Below instructions assume you use a Linux system (Mac OS, Fedora, Ubuntu, etc.) when playing with minion

## How to setup the environment
1. Install node.js: http://nodejs.org/download
2. Install sqlite: http://www.sqlite.org

## How to install
*Assume you saved minion at ~/minion*

1. Move to minion folder : ``` $ cd ~/minion ```

2. Make sure *install.sh* file can be executed : ```$ chmod 755 install.sh```

3. Run *install.sh* : ```$ ./install.sh```

## How to run minion
*Assume you are at ~/minion*

* In development : ```$ coffee main.coffee```

* In production, you're free to choose any methods / tools that you're familiar to run minion as service in Linux for production environment. Some techniques people usually do:
  * https://github.com/nodejitsu/forever
  
  * http://manpages.ubuntu.com/manpages/lucid/man8/start-stop-daemon.8.html

* However, I use [god](http://godrb.com) as my favorite. If you want to try it, make sure you installed god in the system and follow below steps to run minion:
  * Move to *god* folder : ```$ cd ./god```
  
  * Make sure *start.sh* can be executed: ```$ chmod 755 start.sh```
  
  * Run *start.sh* : ```$ ./start.sh```
