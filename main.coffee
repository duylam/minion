express = require 'express'
path = require 'path'
controller = require './app/controller'
flash = require 'connect-flash'

################################################################

A_SECOND = 1000 # in miliseconds
A_MINUTE = 60 * A_SECOND
AN_HOUR = 60 * A_MINUTE
A_DAY = AN_HOUR * 24

################################################################


################################################################

# Setup http web server
app = express()
cacheDuration = A_DAY

app.configure 'development', ->
  cacheDuration = 0

app.configure ->
  app.set 'views', path.join(__dirname, 'app/views')
  app.set 'view engine', 'jade'
  app.use express.cookieParser("yes, i know i'm handsome")
  app.use express.session({ cookie: { maxAge: 10 * A_MINUTE } })
  app.use flash()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.static(path.join(__dirname, 'public'), { maxAge: cacheDuration })
  app.use app.router


# Setup route
app.get '/', (req, res) ->
  controller.home req, res

app.post '/create', (req, res) ->
  controller.create req, res
  
app.get '/game', (req, res) ->
  controller.game req, res
  
# "File not found" page
app.all '/*', (req, res) ->
  res.redirect '/'

################################################################

app.listen 7000