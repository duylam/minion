helpers = require './helpers'
db = require './db'
event = require './event'

class Handler
  setup: (socket, io) ->
    handler = @
    socket.on 'join game', (data) ->
      handler.join data, socket, io
      
    socket.on 'set socket key', (data) ->
      socket.set 'key', data.socketKey, ->
        socket.emit 'socket key ready'
    
  
  send: (data, sender) ->
    message = JSON.stringify(data)
    try
      sender.emit 'message', message
    catch err
      global.logger.error "Error when sending message to websocket. Message: " + message
        
  process: (msg, socket) ->
    try
      data = JSON.parse msg
      switch data.type
        when messageConfig.CHOOSE_HAND then @chooseHand data, socket
        when messageConfig.JOIN_GAME then @join data, socket
          
    catch err
      # do nothing

  
  join: (data, socket, io) ->
    playerName = data.playerName
    gameKey = data.gameKey
    socket.get 'key', (err, key) ->
      unless err
        db.savePlayer gameKey, key, playerName, (err) ->
          socket.join gameKey unless err
          # io.sockets.in(gameKey).emit 'msg', 'hi there'
    
  
  chooseHand: (msg, socket) ->
    db.saveHandForPlayer msg.key, msg.data.up, ->
      # send broadcast
      
  
module.exports = new Handler