define(['utility'], function() {
  var connectToServerOk = false;
  var connectionEstablishedTimeout = 4000; // 4 seconds
  var connectionOptions = {
    port: $('#serverWebsocketPortValue').val()
    , reconnect: true
    , secure: false
    , 'try multiple transports': false
    , 'max reconnection attempts': 15
    , 'force new connection': true
    , transports: [ 'websocket' ]
  };
  
  function onSocketDisconnected() {
    Minion.mediator.publish('disconnected');
  }
  
  function onSocketConnected() {
    connectToServerOk = true;
    var theSocket = this;
    Minion.mediator.publish('connected', theSocket);
  }
  
  function onSocketMessageAvaialble(msg) {
    var messageData = JSON.parse(msg);
    Minion.mediator.publish('message',  messageData); // announce to game.js
  }
  
  function tryToConnect() {
    var socket = io.connect(location.protocol + '//' + location.host, connectionOptions);
    
    socket.on('connect', _.bind(onSocketConnected, socket)); // attach socket object to function
    socket.on('message', onSocketMessageAvaialble);
    socket.on('disconnect', onSocketDisconnected);
      
    setTimeout(function() {
      if( !connectToServerOk ) {
        // IDM (Internet Download Manager) application interferes the websocket connection so
        // we will switch to polling in case web socket doesn't work
        socket.disconnect();
      }
    }, connectionEstablishedTimeout);
  }
  
  Minion.mediator.subscribe('connected', function(socket) {
    Minion.mediator.subscribe('socket receive', function(eventName, cb){
      socket.on(eventName, cb);
    });
    
    Minion.mediator.subscribe('socket send', function(eventName, data){
      socket.emit(eventName, data);
    });
    
    Minion.mediator.publish('socket ready');
  });
    
  Minion.mediator.subscribe('disconnected', function() {
    // Show disconnect alert
  });
    
  // connect with use websocket transport first
  tryToConnect();
    
  // Check the connectivity after several seconds and try on xhr-polling transport 
  setTimeout(function() {
    if( !connectToServerOk ) {
      connectionOptions.transports = [ 'xhr-polling' ];
      tryToConnect();
    }
  }, connectionEstablishedTimeout + 500);
});