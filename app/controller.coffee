db = require './common/db'
helpers = require './common/helpers'

class Controller
  render: (res, viewName, templateData) ->
    templateData ?= {}
    templateData.page = '' unless templateData.page
    templateData.websocketPort = global.config.WEBSOCKET_PORT
    res.contentType 'text/html'
    res.render viewName, templateData
  
  goToGame: (req, res, gameKey, playerName) ->
    helpers.generateUniqueKey playerName, (socketKey) ->
      db.getGame gameKey, (err, obj) ->
        if !err and obj
          req.flash 'gameKey', gameKey
          req.flash 'playerName', playerName
          req.flash 'socketKey', socketKey
          req.flash 'playerAmount', obj.clientAmount
          req.flash 'pickLess', obj.pickLess.toString()
          res.redirect 'game'
        else
          req.flash 'db error', true
          res.redirect '/'

  new: (req, res) ->
    @render res, 'new', { page: 'new' }
    
  create: (req, res) ->
    self = @
    playerName = req.body.nameInput
    pickLess = req.body.pickLessInput
    playerAmount = req.body.peopleAmountInput
    gameKeySeed = playerName + pickLess + playerAmount
    helpers.generateUniqueKey gameKeySeed, (gameKey) ->
      db.saveNewGame gameKey, playerAmount, pickLess, (err) ->
        self.goToGame req, res, gameKey, playerName
  
  add: (req, res) ->
    @goToGame req, res, req.body.gameKeyInput, req.body.nameInput
  
  join: (req, res) ->
    gameKey = req.query.k
    controller = @
    onInvalidGameKey = ->
      req.flash 'invalid-game-key', true
      res.redirect 'game'
    
    unless gameKey
      onInvalidGameKey()
      return
    
    db.getGame gameKey, (err, obj) -> 
      if !err and obj
        templateData =
          pickLess: obj.pickLess
          playerAmount: obj.clientAmount
          gameKey: gameKey
        controller.render res, 'join', templateData
      else
        onInvalidGameKey()
    
    
  home: (req, res) ->
    @render res, 'home',
      page: 'home'
      dbError: req.flash('db error').length > 0
      gameFullError: (req.query.joinFull or '') == 'true'
    
    
  game: (req, res) ->
    @render res, 'game',
      playerName: req.flash('playerName')
      gameKey: req.flash('gameKey')
      pickLess: req.flash('pickLess')
      socketKey: req.flash('socketKey')
      playerAmount: req.flash('playerAmount')

  
    
module.exports = new Controller