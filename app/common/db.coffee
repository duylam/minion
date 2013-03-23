sqlite3 = require 'sqlite3'
path = require 'path'
helpers = require './helpers'

class DB
  
  createDB: (cb) ->
    self = @
    self.db.run "CREATE TABLE IF NOT EXISTS game (key TEXT, createdAt TEXT, clientAmount INTEGER)", (err) ->
      if !err
        self.db.run "CREATE TABLE IF NOT EXISTS client (gameKey TEXT, socketKey TEXT, name TEXT)", (err) ->
          if !err
            cb()
          else
            global.logger.error 'Failed to create CLIENT table'
      else
        global.logger.error 'Failed to create GAME table'  
  
  saveNewGame: (gameKey, peopleNum, firstPlayerName) ->
    @db.run "INSERT INTO game VALUES (?, ?, ?)", [ gameKey, "unknown createdAt", peopleNum]
    @db.run "INSERT INTO client VALUES (?, ?, ?)", [ gameKey, "unknown socket", firstPlayerName]
    
  
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