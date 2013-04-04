define([ 'websocket' ], function() {
  var selectedHand = false;
  Minion.mediator.subscribe('socket ready', function() {
    Minion.mediator.publish('socket send', 'set socket key', { socketKey: Minion.getSocketKey() });
    Minion.mediator.publish('socket receive', 'socket key ready', function() {
      Minion.mediator.publish('socket send', 'join game', { playerName: Minion.getPlayerName() , gameKey: Minion.getGameKey() });  
    });
  });
  
  
  
  /////////////// Add event handlers
  var handUpBtn = $('#btnSelectHandUp');
  var handDownBtn = $('#btnSelectHandDown'); 
  function onSelectHand(isUp, otherHand) {
    otherHand.addClass('select-hand-non-hover');
    handDownBtn.off('click').removeClass('select-hand clickable');
    handUpBtn.off('click').removeClass('select-hand clickable');
    
    //Minion.sendSocket(TYPE.CHOOSE_HAND, { up: isUp });
    selectedHand = true;  
  }
  
  handUpBtn.click(function() {
    onSelectHand(true, handDownBtn);
  });
  
  handDownBtn.click(function() {
    onSelectHand(false, handUpBtn);
  });

  ///////////// Code
  
  
});
