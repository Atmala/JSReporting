AuthStrategy  = require('./authentication')()
reportApp = require('../app')()

module.exports = ->

  initRouts: (app) ->
    app.get '/', AuthStrategy.isAuthenticated, (req, res) ->
      data = {}
      if req.user
        console.log 'USER:  ', req.user
        data.userReportName = 'kateryna.astafieva - Time Report'
        data.userName = req.user?.name
      res.render 'timeReport.ect', data

    app.get '/test', (req, res) ->
      res.render 'test.html'

    app.get '/fail', (req, res) ->
      res.render 'message.ect', { text : "Some EPIC error"}

    app.get '/clearDb', (req, res) ->

      reportApp.clearDb(req.query["collectionName"])
      res.render 'message.ect', { text : "DB cleaned successfuly"}

    app.post '/parse',  (req, res) ->
      items = reportApp.handleTimeReport req.body.txt
      data = {
        userName : req.user?.name
        reportItems : items
      }
      res.render 'parseResult.ect', data


    app.post '/saveCSV',  (req, res) ->
      report = req.body.report
      items = reportApp.handleCsvTimeReport report
      data = {
        title : report.reportTitle
        count : items.length
      }
      res.render 'parseResult.ect', data

    app.get '/timeReport',  (req, res) ->
      person = req.user.name.toLowerCase()
      console.log 'TR requested for: ', person
      reportApp.getTimeReportFor person, (items) ->
        console.log 'TR rows count: ', items.length
        res.json items

    app.post '/timeReport',  (req, res) ->
      console.log "Save request for id:#{req.query["id"]}"
      reportApp.saveReportItem req.body, req.user.name.toLowerCase(), (result) ->
        console.log 'TR row saved: ', result
        res.json result

    app.delete '/timeReport',  (req, res) ->
      id = req.query["id"]
      console.log "Delete request for id:#{id}"
      reportApp.deleteReportItem id
