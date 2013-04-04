event = require './event'
handler = require './socketHandler'

class WebSocketManager
  constructor: ->
    self = @
    
    # Recommened production settings: https://github.com/LearnBoost/Socket.IO/wiki/Configuring-Socket.IO
    @io = require('socket.io').listen(global.config.WEBSOCKET_PORT)
    @io.configure ->
      self.io.disable('browser client')
        .disable('log colors')
        .disable('flash policy server')
        .set('heartbeat interval', 30)
        .set('polling duration', 30)
        .set('transports', [ 'websocket', 'xhr-polling' ])
        .set('log level', 0)
        
    @io.sockets.on 'connection', (socket) ->
      handler.setup socket, self.io
      
    event.on 'send room', (roomName, data) ->
      message = JSON.stringify(data)
      try
        self.io.sockets.in(roomName).emit 'message', message
      catch err
        global.logger.error "Error when sending message to websocket. Message: " + message


module.exports = new WebSocketManager