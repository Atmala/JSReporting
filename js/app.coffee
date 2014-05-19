ReportParser = require('./parse/reportParser')()
reportDbAccessor = require('./db/reportDbAccessor')()
usersDbAccessor = require('./db/userAccountDbAccessor')()

module.exports =  ->

  clearDb: (collectionName) ->
    console.log 'CLEAR FLAG IS:  ', collectionName

    if !collectionName? or collectionName is 'persons' or collectionName is 'users'
      usersDbAccessor.dropAll()
    if !collectionName? or collectionName is 'reports'
      reportDbAccessor.dropAll()

  getTimeReportFor: (person, fn) ->
    reportDbAccessor.findReportsFor person, fn

  saveReportItem: (reportItm, person, fn) ->
    if reportItm._id?
      reportDbAccessor.updateReportItem reportItm._id, person, reportItm.workType, reportItm.date,
        reportItm.project, reportItm.duration, reportItm.task, (id) ->
          console.log 'Updated report item with id ', id
          fn reportItm
    else
      reportDbAccessor.create person, reportItm.workType, reportItm.date,
      reportItm.project, reportItm.duration, reportItm.task, (id) ->
        console.log 'Created report item with id ', id
        reportItm._id = id
        fn reportItm

  deleteReportItem: (id) ->
    reportDbAccessor.delete id

  handleBinaryTimeReport: (data) ->
    reportRows = ReportParser.parse report
    for row, i in reportRows
      console.log 'Row ', i, ': ', row
      reportDbAccessor.create row.date, row.project, row.duration, row.task

    return reportRows

  handleCsvTimeReport: (report) ->
    person = report.reportPersonFName + ' ' + report.reportPersonLName
    reportRows = ReportParser.parseCSV report.reportData
    for row, i in reportRows
      if row.task?.length > 0
        now = new Date()
        date = new Date(row.date + '-' + now.getFullYear() + '-' + now.toTimeString())
        console.log '---------The date:   ', date
        reportDbAccessor.create person, row.type, date, row.project, row.duration, row.task

    return reportRows

  logRequest: (req, res, next) ->
    console.log '=============================================='
    console.log '%s requst received URL: %s', req.method, req.url.substring(0, 15)
    console.log '=============================================='
    next()

