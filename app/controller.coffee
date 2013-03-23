db = require './common/db'

class Controller
  render: (res, viewName, templateData) ->
    templateData ?= {}
    res.contentType 'text/html'
    res.render viewName, templateData
  
  home: (req, res) ->
    @render res, 'home'
    
  create: (req, res) ->
    db.saveNewGame 'unknown game key', req.body.peopleAmountInput, req.body.nameInput
    req.flash 'fromCreation', 'true'
    req.flash 'gameKey', 'unknown game key'
    req.flash 'playerName', req.body.nameInput
    res.redirect 'game'
    
  game: (req, res) ->
    @render res, 'game', { d: req.flash('playerName') }

module.exports = new Controller