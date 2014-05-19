  coffeeScript = require 'coffee-script'
  express = require 'express'
  assets = require 'connect-assets'
  jsPrimer = require 'connect-assets-jsprimer'
  reportApp = require('./js/app')()
  mongo = require('./js/db/mongo')()
  authInitializer = require('./js/modules/authentication')()
  router = require('./js/modules/routing')()

  app = express()

  app.use assets()
  jsPrimer.loadFiles(assets)

  app.use "/", express.static(__dirname + "/assets")
  app.use express.cookieParser('keyboard cat')
  app.use express.session()
  app.use express.bodyParser()

  authInitializer.setup app

  app.use reportApp.logRequest
  app.use app.router

  ECT = require 'ect'
  ectRenderer = ECT({ watch: true, root: __dirname + '/views' })

  app.engine('.ect', ectRenderer.render)
  app.engine('.html', ectRenderer.render)

  #init routs
  router.initRouts app
  mongo.initConnection()

  app.listen 3000
  console.log 'Listening on port 3000'