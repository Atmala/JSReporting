require.config 
  baseUrl: '/js'
  paths: {
    jquery: 'lib/jquery'
    _: 'lib/underscore'
    bootstr: 'lib/bootstrap'
    xlsx: 'lib/xlsx'
    utils: 'lib/utils'
    data: 'angModules/data'
  }
  shim: {
    'underscore': {exports: '_'}
    'lib/angular/angular': {exports: 'angular'}
    'angular/angular-ui': ['angular/angular']
    'angular/angular-resource.min': ['angular/angular']
  }

require [
  'jquery'
  '_'], ($) ->
    require [
      'bootstr/bootstrap.min'
      'bootstr/bootstrap-datepicker'
      'xlsx/jszip'
      'xlsx/xlsx'
      'lib/crossfilter.v1'
      'lib/d3.v2'
      'lib/date'], ()->
        console.log 'All external libraries loaded'

  #
  #require([…], function () { … });

require [
  'jquery'
  'reportApp'], ($, ReportApp) ->
    $(document).ready () ->
      window.reportApp = new ReportApp()


require ['lib/angular/angular'], (angular) ->
  define 'angular',  () -> return angular
  require [
    'lib/angular/angular'
    'lib/angular/angular-resource.min'
    'lib/angular/angular-strap'
    'controllers/reportController'
    'controllers/statisticController'], (angular) ->
      angular.bootstrap document, ['reporting', 'statistic']

      console.log 'All angular modules loaded'
