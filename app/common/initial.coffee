
A_SECOND = 1000 # in miliseconds
A_MINUTE = 60 * A_SECOND
AN_HOUR = 60 * A_MINUTE
A_DAY = AN_HOUR * 24

environment = 
  name : process.env.NODE_ENV or 'development'
  on : (envName, trueFn, falseFn) -> 
    if envName == @name
      trueFn()
    else
      falseFn() if falseFn

config =
  WEBSOCKET_PORT: 443
  WEB_PORT: 80
  STATIC_FILE_CACHE_DURATION: A_DAY
  
environment.on 'development', ->
  config.WEBSOCKET_PORT = 8000
  config.WEB_PORT = 7000
  config.STATIC_FILE_CACHE_DURATION = 0

global.config = config
global.environment = environment