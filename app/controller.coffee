class Controller
  render: (res, viewName, templateData) ->
    templateData ?= {}
    res.contentType 'text/html'
    res.render viewName, templateData
  
  home: (req, res) ->
    @render res, 'home'
    
  game: (req, res) ->
    @render res, 'game'
  

module.exports = new Controller