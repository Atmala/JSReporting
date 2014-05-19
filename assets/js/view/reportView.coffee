define ['jquery', 'model/reportModel'], ($, ReportModel) ->

  class ReportView

    getBinFile = ->
      reportApp.GoogleDriveHelper.getFileList('title contains \'kateryna\'', (resp) ->
          $('#fileCaption').html(resp.items[0].title);
          reportApp.GoogleDriveHelper.getReportByFileId(resp.items[0].id, reportApp.GoogleDriveHelper.FormatEnum.binary,(resp) ->
            console.log('File response:', resp.substr(0, 250))
            currentReport = new ReportModel(resp)
            xlResult = XLSX.read( resp, {type: 'base64'})
            console.log('Parsed:', xlResult)
            parseFile(currentReport)
          )
      )

    getAllReports = ->
      clearDb('reports')

      reportApp.GoogleDriveHelper.getFileList('title contains \'Time Report\'', (resp) ->
        for item in resp.items
          getCSVFileById item.id, item.title
      )

    getCSVFileById = (id, title) ->
      reportApp.GoogleDriveHelper.getReportByFileId(id, reportApp.GoogleDriveHelper.FormatEnum.csv,(resp) ->
        console.log('File response:', resp.substr(0, 250))
        report = new ReportModel(resp, title)
        save report
      )

    getCSVFileByName = (name) ->
      reportApp.GoogleDriveHelper.getReportByFileName(name, reportApp.GoogleDriveHelper.FormatEnum.csv,(resp) ->
        console.log('File response:', resp.substr(0, 250))
        report = new ReportModel(resp, name)
        save report
      )

    parseFile = (report)->
      $.ajax({
        type: "POST",
        url: 'http://localhost:3000/parse',
        data: {txt: report.reportData},
        success: (data)->
          $('#fileInfo').html(data)
      })

    save = (report) ->
      $.ajax({
        type: "POST",
        url: 'http://localhost:3000/saveCSV',
        data: {report: report},
        success: (data)->
          $('#fileInfo').html(data)
        })

    clearDb = (collection)->
      $.ajax({
        type: "GET"
        url: 'http://localhost:3000/clearDb'
        data:  { collectionName: collection}
        success: (data)->
          $('#fileInfo').html(data)
      })

    getAllReports: ->
      reportApp.GoogleDriveHelper.authenticate(getAllReports)

    getReportByName: (name) ->
      reportApp.GoogleDriveHelper.authenticate(
        () ->
          getCSVFileByName(name)
      )