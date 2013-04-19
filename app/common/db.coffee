sqlite3 = require 'sqlite3'
path = require 'path'
helpers = require './helpers'
DateString = require './dateString'

HAND_DOWN = -1
HAND_UNSET = 0
HAND_UP = 1

class DB  
  createDB: (cb) ->
    self = @
    self.db.run "CREATE TABLE IF NOT EXISTS game (key TEXT, createdAt TEXT, clientAmount INTEGER, pickLess TEXT)", (err) ->
      if !err
        self.db.run "CREATE TABLE IF NOT EXISTS client (gameKey TEXT, socketKey TEXT, name TEXT, handType INTEGER)", (err) ->
          if !err
            cb()
          else
            global.logger.error 'Failed to create CLIENT table'
      else
        global.logger.error 'Failed to create GAME table'  
  
  savePlayer: (gameKey, socketKey, playerName, cb) ->
    @db.run "INSERT INTO client VALUES (?, ?, ?, ?)", [ gameKey, socketKey, playerName, HAND_UNSET], cb
    
  saveHandForPlayer: (socketKey, handUp, cb) ->
    handType = if handUp then HAND_UP else HAND_DOWN
    @db.run "UPDATE client SET handType = ? WHERE socketKey=?", [ handType, socketKey ], cb
  
  saveNewGame: (gameKey, peopleNum, pickLess, cb) ->
    @db.run "INSERT INTO game VALUES (?, ?, ?, ?)", [ gameKey, DateString.fromDate(new Date).toString(), peopleNum, pickLess], cb
        
  getPlayersInGame: (gameKey, cb) ->
    @db.all "SELECT * FROM client WHERE gameKey=?", [ gameKey ], (err, rows) ->
      if !err
        cb null, rows.map( (e) -> { name: e.name, handUnset: e.handType == HAND_UNSET, handUp: e.handType == HAND_UP, socketKey: e.socketKey } )          
      else
        cb err
  
  getGame: (gameKey, cb) ->
    @db.get "SELECT * FROM game WHERE key=?", [ gameKey ], (err, row) ->
      if !err and row
        cb null,
          id: row.key
          createdAt: DateString.fromString(row.createdAt).toDate()
          clientAmount: row.clientAmount
          pickLess: row.pickLess == 'true'
          
      else
        cb err
  
  init: (cb) ->
    self = @
    @db = new sqlite3.Database path.join(__dirname, '../../var/miniondb.sqlite3'), (err) ->
      if !err
        global.environment.on 'development', ->
          self.db.run "DROP TABLE IF EXISTS game", (err) ->
            self.db.run "DROP TABLE IF EXISTS client", (err) ->
              self.createDB cb
              
        , ->
          self.createDB cb
      
      else
        global.logger.error 'Failed to create sqlite database file'

module.exports = new DB