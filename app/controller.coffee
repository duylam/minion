class Controller
  render: (res, viewName, templateData) ->
    templateData ?= {}
    res.contentType 'text/html'
    res.render viewName, templateData
  
  home: (req, res) ->
    @render res, 'home'
    
  create: (req, res) ->
    req.flash 'test', 'data'
    res.redirect 'game'
    
  game: (req, res) ->
    @render res, 'game', { d: req.flash('test') }

module.exports = new Controller