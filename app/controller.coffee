db = require './common/db'
helpers = require './common/helpers'

class Controller
  render: (res, viewName, templateData) ->
    templateData ?= {}
    templateData.page = '' unless templateData.page
    templateData.websocketPort = global.config.WEBSOCKET_PORT
    res.contentType 'text/html'
    res.render viewName, templateData
  
  home: (req, res) ->
    @render res, 'home', { page: 'home' }
    
  join: (req, res) ->
    @doJoin req, res, req.body.gameKeyInput, req.body.nameInput
    
  about: (req, res) ->
    @render res, 'about', { page: 'about' }
    
  create: (req, res) ->
    self = @
    playerName = req.body.nameInput
    pickLess = req.body.pickLessInput
    playerAmount = req.body.peopleAmountInput
    gameKeySeed = playerName + pickLess + playerAmount
    helpers.generateUniqueKey gameKeySeed, (gameKey) ->
      db.saveNewGame gameKey, playerAmount, pickLess, ->
        self.doJoin req, res, gameKey, playerName
    
  game: (req, res) ->
    @render res, 'game',
      playerName: req.flash('playerName')
      gameKey: req.flash('gameKey')
      pickLess: req.flash('pickLess')
      socketKey: req.flash('socketKey')
      playerAmount: req.flash('playerAmount')

  doJoin: (req, res, gameKey, playerName) ->
    helpers.generateUniqueKey playerName, (socketKey) ->
      db.getGame gameKey, (err, obj) ->
        req.flash 'gameKey', gameKey
        req.flash 'playerName', playerName
        req.flash 'socketKey', socketKey
        req.flash 'playerAmount', obj.clientAmount
        req.flash 'pickLess', obj.pickLess
        res.redirect 'game'
    
module.exports = new Controller