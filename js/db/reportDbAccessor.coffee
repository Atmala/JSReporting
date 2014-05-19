mongoose = require 'mongoose'
ReportItem = require "./model/reportItem"

module.exports = ->

    findReportsFor: (person, fn) ->
      ReportItem.find({person: person}, '_id date project task workType duration')
      .sort('-date')
      .exec( (err, reportLst)  ->
        if reportLst
          console.log 'Found report items for ', person
          fn reportLst if fn
        else
          console.log 'No report found for ', person
      )

    updateReportItem: (id, person, workType, date, project, duration, task, fn) ->
      if id?
        console.log 'Try to find ----> ', id
        ReportItem.findByIdAndUpdate(
          id,
          {workType: workType, date: date, project: project, duration: duration, task: task},
          {upsert: true},
          () ->
            console.log 'Save\\Update report item with id ', id
            fn id if fn
        )

    findReport: (person, workType, date, project, duration, task, fn) ->
      ReportItem.findOne {person: person, workType : workType, date: date, project : project, duration : duration, task : task}, (err, reportItm) ->
        if reportItm
          console.log 'Found report item for date', date
          fn null, reportItm if fn

    dropAll: (fn) ->
      ReportItem.collection.drop (err) ->
        console.log 'All reports dropped'
        fn? err, null

    delete: (id) ->
      ReportItem.remove({ _id: id }, (err)  ->
        if !err?
          console.log "Report item with id #{id} removed sucessfuly"
        else
          console.log "Error on romoving item with id #{id} the error: #{err}"
      )

    create: (person, workType, date, project, duration, task, fn) ->
      newItem = new ReportItem {
        person: person
        workType: workType
        date: date
        project: project
        duration: duration
        task: task
      }

      newItem.save (err, itm) ->
        if not itm?
          console.log 'An error happend during saving reportItem: ', err
        else
          console.log 'Saved: ', itm
          fn itm._id if fn
