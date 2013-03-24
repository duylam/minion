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
    Minion.mediator.publish('connected');
  }
  
  function onSocketMessageAvaialble(msg) {
    var messageData = JSON.parse(msg);
    Minion.mediator.publish('message',  messageData); // announce to game.js
  }
  
  function tryToConnect() {
    var socket = io.connect(location.protocol + '//' + location.host, connectionOptions);
    Minion.sendSocket = function(type, data) {
      socket.send(JSON.stringify({
        type: type
        , key: $('#server_socketKey').val()
        , data: data
      }));
    };
    
    socket.on('connect', onSocketConnected);
    socket.on('message', onSocketMessageAvaialble);
    socket.on('disconnect', onSocketDisconnected);
      
    setTimeout(function() {
      if( !connectToServerOk ) {
        // IDM (Internet Download Manager) application interferes the websocket connection so
        // we will switch to polling in case web socket doesn't work
        socket.removeListener('connect', onSocketConnected);
        socket.removeListener('message', onSocketMessageAvaialble);
        socket.removeListener('disconnect', onSocketDisconnected);
        socket.disconnect();
      }
    }, connectionEstablishedTimeout);
  }
  
  Minion.mediator.subscribe('connected', function() {
    // Hide disconnect alert
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