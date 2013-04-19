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
        
    socket.on 'set hand', (data) ->
      handler.setHand data, socket, io
  
  
  broadcastHandUpdated: (gameKey, socket, io, joinSocketToRoom = false) ->
    db.getPlayersInGame gameKey, (err, players) ->
      unless err
        # group socket into room
        socket.join gameKey if joinSocketToRoom
        
        # tell others that new player joined
        io.sockets.in(gameKey).emit 'update players state', { players: players }
        
        # everybody selects hand ?
        db.getGame gameKey, (err, game) ->
          unless err
            if players.length == game.clientAmount and players.every( (p) -> !p.handUnset )
              io.sockets.in(gameKey).emit 'game finished'
  
  
  join: (data, socket, io) ->
    playerName = data.playerName
    gameKey = data.gameKey
    handler = @
    
    # Check full ?
    db.getGame gameKey, (err, game) ->
      unless err
        db.getPlayersInGame gameKey, (err, players) ->
          unless err
            if players.length < game.clientAmount
              socket.get 'key', (err, socketKey) ->
                unless err
                  db.savePlayer gameKey, socketKey, playerName, (err) ->
                    unless err
                      handler.broadcastHandUpdated gameKey, socket, io, true
            
            else
              # game is full
              socket.emit 'join game failed due to full'
  
  setHand: (data, socket, io) ->
    handler = @
    socket.get 'key', (err, socketKey) ->
      unless err
        db.saveHandForPlayer socketKey, data.up, (err) ->
          unless err
            handler.broadcastHandUpdated data.gameKey, socket, io
      
  
module.exports = new Handler