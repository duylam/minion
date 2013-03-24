class Handler
  send: (data, socket) ->
    message = JSON.stringify(data)
    try
      socket.emit 'message', message
    catch err
      global.logger.error "Error when sending message to websocket. Message: " + message
        
  process: (msg, socket) ->
    try
      data = JSON.parse msg
      @send data, socket
    catch err
      # do nothing
  
module.exports = new Handler