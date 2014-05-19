define  ['view/reportView', 'google/driveManager', 'controls/reportItemForm'], (ReportView, DriveManager, ReportItemForm) ->

  class ReportApp
    constructor: ->
      @ReportView = new ReportView()
      @GoogleDriveHelper = new DriveManager()
      @TimeReport = new ReportItemForm()

      console.log 'reportApp initiated'
