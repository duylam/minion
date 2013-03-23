sqlite3 = require 'sqlite3'
path = require 'path'
helpers = require './helpers'
DateString = require './dateString'

class DB
  
  createDB: (cb) ->
    self = @
    self.db.run "CREATE TABLE IF NOT EXISTS game (key TEXT, createdAt TEXT, clientAmount INTEGER, pickLess INTEGER)", (err) ->
      if !err
        self.db.run "CREATE TABLE IF NOT EXISTS client (gameKey TEXT, socketKey TEXT, name TEXT)", (err) ->
          if !err
            cb()
          else
            global.logger.error 'Failed to create CLIENT table'
      else
        global.logger.error 'Failed to create GAME table'  
  
  saveNewGame: (gameKey, socketKey, peopleNum, firstPlayerName, pickLess) ->
    @db.run "INSERT INTO game VALUES (?, ?, ?, ?)", [ gameKey, DateString.fromDate(new Date).toString(), peopleNum, pickLess]
    @db.run "INSERT INTO client VALUES (?, ?, ?)", [ gameKey, socketKey, firstPlayerName]
    
  
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