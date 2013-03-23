express = require 'express'
path = require 'path'
require './app/common/initial'

require './app/common/logger'
controller = require './app/controller'
flash = require 'connect-flash'
db = require './app/common/db'

################################################################

A_SECOND = 1000 # in miliseconds
A_MINUTE = 60 * A_SECOND
AN_HOUR = 60 * A_MINUTE
A_DAY = AN_HOUR * 24

################################################################


################################################################

# Setup http web server
app = express()
cacheDuration = 0

global.environment.on 'production', ->
  cacheDuration = A_DAY

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
  
app.get '/join', (req, res) ->
  controller.join req, res

app.get '/about', (req, res) ->
  controller.about req, res


app.get '/game', (req, res) ->
  controller.game req, res
  
# "File not found" page
app.all '/*', (req, res) ->
  res.redirect '/'

################################################################

port = 7000
db.init ->
  app.listen port
  global.logger.info 'Web server started on port ' + port
  
