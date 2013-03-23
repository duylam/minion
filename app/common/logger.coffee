# https://github.com/wavded/winston-mail
winston = require 'winston'

logger = new winston.Logger { exitOnError: false }
logger.add winston.transports.Console,
  timestamp: true
  colorize: true

global.logger = logger