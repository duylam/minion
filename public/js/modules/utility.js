define([], function() {
  global = {};
  global.getGameKey = function() {
    return $('#server_gameKey').val();
  };
  global.isPickLess = function() {
    return $('#server_pickLess').val() == 'true';
  };
  global.getPlayerName = function() {
    return $('#server_playerName').val();
  };
  global.getSocketKey = function() {
    return $('#server_socketKey').val();
  };
  
  
  
  window.Minion = global;
  window.Minion.mediator = Mediator;
});