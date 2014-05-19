mongoose = require 'mongoose'
UserAccount = require "./model/user"

module.exports = ->
    findByName: (name, fn) ->
      UserAccount.findOne {name: name}, (err, user) ->
        if user
          console.log 'Found user ', user
          fn null, user
        else
          console.log "Cannot find user with #{name} name: #{err}"
          fn err, null

    findByEmail: (email, fn) ->
      UserAccount.findOne {email: email}, (err, user) ->
        if user?
          console.log 'Found user ', user
          fn null, user
        else
          console.log "Cannot find user with #{email} email: #{err}"
          fn err, null

    dropAll: (fn) ->
      UserAccount.collection.drop (err) ->
        console.log 'All users dropped'
        fn? err, null

    create: (name, email, fn) ->
      newUser = new UserAccount {
      name: name
      email: email
      }

      newUser.save (err, user) ->
        if user
          fn null, user
        else
          fn err, null
