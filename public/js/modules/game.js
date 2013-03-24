define([ 'websocket' ], function() {
  Minion.mediator.subscribe('message',  function(msg) {
    alert(JSON.stringify(msg));
  });
  
  Minion.sendSocket(100);
});
