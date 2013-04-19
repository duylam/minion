define(['utility', 'websocket' ], function() {
  var playerAmount = parseInt( $('#server_playerAmount').val() );
  var playerRows = $('#playerRow1 > div, #playerRow2 > div');
  Minion.mediator.subscribe('socket ready', function() {
    Minion.mediator.publish('socket send', 'set socket key', { socketKey: Minion.getSocketKey() });
    Minion.mediator.publish('socket receive', 'socket key ready', function() {
      Minion.mediator.publish('socket send', 'join game', { playerName: Minion.getPlayerName() , gameKey: Minion.getGameKey() });  
    });
    Minion.mediator.publish('socket receive', 'join game failed due to full', function() {
      location.href = '/?joinFull=true'
    });
    Minion.mediator.publish('socket receive', 'game finished', function() {
      // Show result
    });
    Minion.mediator.publish('socket receive', 'update players state', function(data) {
       var players = data.players;
       //  data.players  name    handUnset handUp
       playerRows.each(function(ind) {
         var p = players[ind];
         var view = $(this);
         if(p && !view.hasClass('hide') ) {
           view.find('.playerName').text(p.name);
           if( !p.handUnset ) {
             var handElement = view.find('.hand');
             handElement.fadeOut(500,function() {
               handElement.addClass(p.handUp ? 'up' : 'down').fadeIn(500);
             }); 
           }
         }
       });
       
       $('#handSelectSection').fadeIn(500);
    });
  });
  
  /////////////// Add event handlers
  var handUpBtn = $('#btnSelectHandUp');
  var handDownBtn = $('#btnSelectHandDown'); 
  function onSelectHand(isUp, otherHand) {
    // Update UI
    otherHand.addClass('select-hand-non-hover');
    handDownBtn.off('click').removeClass('select-hand clickable');
    handUpBtn.off('click').removeClass('select-hand clickable');
    $('#handSelectDescPanel').fadeOut(500);
    
    // Let server know
    Minion.mediator.publish('socket send', 'set hand', { up: isUp, gameKey: Minion.getGameKey() });
    
    // Jump to board
    location.href = $('#linkGoToBoard').attr('href');    
  }
  
  handUpBtn.click(function() {
    onSelectHand(true, handDownBtn);
  });
  
  handDownBtn.click(function() {
    onSelectHand(false, handUpBtn);
  });

  ///////////// Code
  
  // Show join link
  var joinLink = location.protocol + '//' + location.host + '/join?k=' + Minion.getGameKey();
  $('#copyJoinLinkInput').attr('href', joinLink).text(joinLink);
  
  // Show pick label
  if(Minion.isPickLess()) $('#pickLessLabel').removeClass('hide');
  else $('#pickMoreLabel').removeClass('hide');
  
  // Unhide player rows
  var lagestIndex = playerAmount - 1;
  if(playerAmount > 5) {
    $('#playerRow2').removeClass('hide');
  }
  
  playerRows.each(function(ind) {
    if(ind <= lagestIndex) {
      $(this).removeClass('hide');
    }
  });
});
