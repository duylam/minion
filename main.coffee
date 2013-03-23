express = require 'express'
path = require 'path'
controller = require './app/controller'

################################################################

A_SECOND = 1000 # in miliseconds
A_MINUTE = 60 * A_SECOND
AN_HOUR = 60 * A_MINUTE
A_DAY = AN_HOUR * 24

################################################################


################################################################

# Setup http web server
app = express()
app.configure ->
  app.set 'views', path.join(__dirname, 'app/views')
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.static(path.join(__dirname, 'public'), { maxAge: A_DAY })
  app.use app.router


# Setup route
app.get '/', (req, res) ->
  controller.home req, res
  
app.get '/game', (req, res) ->
  controller.game req, res
  
# "File not found" page
app.all '/*', (req, res) ->
  res.redirect '/'

################################################################

app.listen 7000