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
  
  join: (data, socket, io) ->
    playerName = data.playerName
    gameKey = data.gameKey
    socket.get 'key', (err, socketKey) ->
      unless err
        db.savePlayer gameKey, socketKey, playerName, (err) ->
          unless err
            db.getPlayersInGame gameKey, (err, players) ->
              unless err
                # group socket into room
                socket.join gameKey
                
                # tell others that new player joined
                io.sockets.in(gameKey).emit 'update players state', { players: players }
  
  chooseHand: (msg, socket) ->
    db.saveHandForPlayer msg.key, msg.data.up, ->
      # send broadcast
      
  
module.exports = new Handler