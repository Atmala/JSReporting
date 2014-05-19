mongoose = require 'mongoose'

module.exports = ->

  initConnection: ->
    mongoose.connect 'mongodb://localhost/report'

    #Init db#
    db = mongoose.connection
    db.on 'error', console.error.bind(console, 'connection error:')
    db.once 'open', ->
      console.log 'Db opened successfuly'
