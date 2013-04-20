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
      

module.exports = new WebSocketManager