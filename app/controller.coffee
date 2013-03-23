db = require './common/db'
helpers = require './common/helpers'

class Controller
  render: (res, viewName, templateData) ->
    templateData ?= {}
    templateData.page = '' unless templateData.page
    res.contentType 'text/html'
    res.render viewName, templateData
  
  home: (req, res) ->
    @render res, 'home', { page: 'home' }
    
  join: (req, res) ->
    @render res, 'join', { page: 'join' }
    
  about: (req, res) ->
    @render res, 'about', { page: 'about' }
    
  create: (req, res) ->
    gameKey = ''
    playerName = req.body.nameInput
    pickLessValueString = req.body.pickLessInput
    pickLess = if pickLessValueString == 'true' then 1 else 0
    playerAmount = req.body.peopleAmountInput
    gameKeySeed = playerName + pickLess + playerAmount
    helpers.generateUniqueKey gameKeySeed, (key) ->
      gameKey = key
      helpers.generateUniqueKey playerName, (key2) ->
        playerSocketKey = key2
        db.saveNewGame gameKey, playerSocketKey, playerAmount, playerName, pickLess
        req.flash 'gameKey', gameKey
        req.flash 'playerName', playerName
        req.flash 'pickLess', pickLessValueString
        req.flash 'socketKey', playerSocketKey
        req.flash 'playerAmount', playerAmount
        res.redirect 'game'
    
  game: (req, res) ->
    @render res, 'game',
      playerName: req.flash('playerName')
      gameKey: req.flash('gameKey')
      pickLess: req.flash('pickLess')
      socketKey: req.flash('socketKey')
      playerAmount: req.flash('playerAmount')

module.exports = new Controller