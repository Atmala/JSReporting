_ = require 'underscore'
passport = require 'passport'
GoogleStrategy = require('passport-google').Strategy
userDbAccessor = require('../db/userAccountDbAccessor')()

module.exports =  ->
  setup: (app) ->
    app.use passport.initialize()
    app.use passport.session()

    passport.serializeUser (user, done) ->
      console.log 'Serialize user ' + user
      done null, user.email

    passport.deserializeUser (email, done) ->
      console.log 'Deserialize user for ' + email
      userDbAccessor.findByEmail email, (err, user) ->
        done err, user

    passport.use 	new GoogleStrategy {
      returnURL: 'http://localhost:3000/auth/google/return',
      realm: 'http://localhost:3000/'
      },
      (identifier, profile, done) ->
        email = (_.first profile.emails).value
        userDbAccessor.findByEmail email, (err, user) ->
          if !user?
            userDbAccessor.create profile.displayName, email, (err, user) ->
              done(err, user)
          else
            done(err, user)

    app.get '/auth/google',  passport.authenticate('google')

    app.get '/auth/google/return', passport.authenticate('google', { failureRedirect: '/fail' }),
    (req, res) ->
      res.redirect '/'

  isAuthenticated: (req, res, next) ->
    console.log "check athentication"

    if req.isAuthenticated()
      console.log 'user athenticated'
      next()
    else
      console.log 'user not authenticated redirecting to "/auth/google"'
      res.redirect '/auth/google'