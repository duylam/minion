define(['utility', 'websocket' ], function() {
  var playerAmount = parseInt( $('#server_playerAmount').val() );
  var playerRows = $('#playerRow1 > div, #playerRow2 > div');
  var directionAnimationIntervalId = 0;
  var chatContainerCtrl = $('#chatMessageContainer');
  var chatInputCtrl = $('#chatInput');
  var handSelected = false;
  Minion.mediator.subscribe('socket ready', function() {
    Minion.mediator.publish('socket send', 'set socket key', { socketKey: Minion.getSocketKey() });
    Minion.mediator.publish('socket receive', 'socket key ready', function() {
      Minion.mediator.publish('socket send', 'join game', { playerName: Minion.getPlayerName() , gameKey: Minion.getGameKey() });  
    });
    Minion.mediator.publish('socket receive', 'join game failed due to full', function() {
      location.href = '/?joinFull=true'
    });
    Minion.mediator.publish('socket receive', 'receive chat message', function(data) {
      chatContainerCtrl.append(
        $('<div />', { class: 'chat-entry' })
          .append($('<span />', { class: 'label chat-username' }).text(data.sender))
          .append($('<span />', { class: 'chat-message' }).text(data.message))
      );
      
      // Jump to bottom
      chatContainerCtrl.scrollTop( chatContainerCtrl.prop("scrollHeight") );
    });
    Minion.mediator.publish('socket receive', 'game finished', function(data) {
      // Since this event is fired immediated from server, we need to wait for while
      // so that animate effect finished, after that we can run
      setTimeout(function() {
        var handToHide = data.selectUp ? 'down' : 'up';
        $('#progressHeader').addClass('hide');
        
        if(data.draw) {
          $('#drawFinishingLabel').removeClass('hide');
        } else {
          $('#finishingLabel').removeClass('hide');
          // Show losers
          playerRows.each(function(ind) {
            var view = $(this);
            if( !view.hasClass('hide') && view.find('.hand').hasClass(handToHide) ) view.addClass('invisible');
          });
        }
      }, 1500);
    });
    Minion.mediator.publish('socket receive', 'update players state', function(data) {
       var players = data.players;
       playerRows.each(function(ind) {
         var p = players[ind];
         var view = $(this);
         if(p && !view.hasClass('hide') ) {
           if( !view.data('player-joined') ) {
             chatContainerCtrl.append(
               $('<div />', { class: 'chat-entry' }).text(p.name + ' đã vào bàn')
             );
             view.data('player-joined', true);
           }
      
           view.find('.playerName').text(p.name);
           if( !p.handUnset ) {
             view.removeClass('hand-unset');
             var handElement = view.find('.hand');
             
             // Update hands only once
             if( !handElement.hasClass('up') && !handElement.hasClass('down') ) {
               if( !handElement.data('player-hand-selected') ) {
                 chatContainerCtrl.append(
                   $('<div />', { class: 'chat-entry' }).text(p.name + ' đã chọn tay')
                 );
                 handElement.data('player-hand-selected', true);
               }
               handElement.fadeOut(500,function() {
                 handElement.addClass(p.handUp ? 'up' : 'down');
                 
                 // Don't show the result in UI if user haven't selected hand
                 if( !handSelected ) handElement.addClass('hide-hand');
                 
                 handElement.fadeIn(500);
               });  
             }
           }
         }
       });
       
       $('#handSelectSection').fadeIn(500, function() {
          var marginLeftValue = 0;
          var maxMarginLeftValue = 10;
          var increaseUp = true;
          var imageCtrl = $('#handDescImage');
          directionAnimationIntervalId = setInterval(function() {
            if( increaseUp ) {
              ++marginLeftValue;
              if( marginLeftValue > maxMarginLeftValue ) increaseUp = false;
            } else {
              --marginLeftValue;
              if( marginLeftValue < 0 ) increaseUp = true;
            }
            
            imageCtrl.css('margin-left', marginLeftValue + 'px');
          }, 30);
       });
    });
  });
  
  /////////////// Add event handlers
  var handUpBtn = $('#btnSelectHandUp');
  var handDownBtn = $('#btnSelectHandDown'); 
  function onSelectHand(isUp, otherHand) {
    // Update UI
    otherHand.addClass('hide');
    handDownBtn.off('click').removeClass('select-hand clickable');
    handUpBtn.off('click').removeClass('select-hand clickable');
    $('#handSelectDescPanel').fadeOut(500);
    clearInterval(directionAnimationIntervalId);
    handSelected = true;
    
    // Show the user the result of hand of other users
    playerRows.find('.hand').removeClass('hide-hand');
    
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
  
  chatInputCtrl.keypress(function(e) {
    if(e.which == 13) {
      var msg = chatInputCtrl.val();
      if( msg ) {
        chatInputCtrl.val('');
        Minion.mediator.publish('socket send', 'send chat message', { gameKey: Minion.getGameKey(), sender: Minion.getPlayerName(), message: msg });  
      }
    }
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
  
  // Show warning when going to another page
  window.onbeforeunload = function() {
    return 'Rời khỏi phòng là không vào lại được đâu đó !';  
  };
});
