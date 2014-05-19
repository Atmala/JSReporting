define ['jquery', 'data/reportData', 'data/utilData', 'angModules/gridModule', 'angModules/formValidation'], ($, repData, utilData, grid) ->

  return angular.module('reporting', ['reportData', 'utilData', 'gridModule', '$strap.directives', 'formValidation' ])
    .controller('timeReportCtrl',
      ($scope, $rootScope, TimeReport, Projects, WorkTypes) ->

        TimeReport.reportItems(
          (items) ->
            console.log 'Report data received: ', items
            #angular formating works only for Date obj and we receive string from server
            item.date = new Date(item.date) for item in items
            $scope.reportItems = items

            $rootScope.$emit 'gridDataLoaded', items
        )

        $scope.td = new Date()

        setupDefaultItem = () ->
          #Setup DEFAULTS
          $scope.reportItem = {};
          $scope.reportItem.date = Date.now();

        $scope.allProjects = Projects
        $scope.allWorkTypes = WorkTypes

        setupDefaultItem()

        addReportItem = (reportItem) =>
          if !reportItem._id?
            reportItem = new TimeReport(reportItem)
            $scope.reportItems.unshift(reportItem)


          reportItem.$save((result) ->
            #angular formating works only for Date obj and we receive string from server
            reportItem.date = new Date(result.date)
          )

          setupDefaultItem();



        $scope.addReport = addReportItem

        $rootScope.$on('editReportItem',
        (event, reportItem) ->
          $scope.reportItem = reportItem;
        )

        $rootScope.$on('deleteReportItem',
        (event, reportItem) ->
          reportItem.$remove()
        )
    )
    .directive('dependsOn', () ->
      #Think of better place and way for that list
      projectNamesLst = ['Ill', 'Vacation', 'Day off']

      (scope, element, attr) ->

        onMasterChanged = () ->
          isWorkProject = $.inArray(scope.reportItem.project, projectNamesLst) >= 0
          element.val '' if isWorkProject
          element.prop 'disabled', isWorkProject

          element.change()


        scope.$watch 'reportItem.project', onMasterChanged

        $('#' + attr.dependsOn).change onMasterChanged
    )
