angular.module('gridModule', [])
    .controller('gridController',
      ($scope, $rootScope) ->

        $scope.pagingOptions = {
            pageSizes: [50, 100, 500],
            pageSize: 50,
            pagesCount: 1,
            currentPage: 1
        }

        $rootScope.$on('gridDataLoaded', (event, gridData) ->

            $scope.data = gridData

            updatePageCount(gridData.length, $scope.pagingOptions)

            $scope.$watch('data'
              () ->
                $scope.pagingOptions.currentPage = 1;
                updatePageData();
              true)

            $scope.$watch('pagingOptions',
              () ->
                updatePageData()
              true)
        )

        $scope.editItem = (item) ->
          $rootScope.$emit('editReportItem', item)

        $scope.deleteItem = (item) ->
          $scope.data = _.without($scope.data, item)
          $rootScope.$emit('deleteReportItem', item)

        updatePageData = () ->
            startIndex = ($scope.pagingOptions.currentPage - 1) * $scope.pagingOptions.pageSize
            updatePageCount($scope.data.length, $scope.pagingOptions)
            $scope.page = $scope.data.slice(startIndex, startIndex + $scope.pagingOptions.pageSize)


        updatePageCount = (totalCount, pagingOptions) ->
            pagingOptions.pagesCount = Math.floor(totalCount/pagingOptions.pageSize)
            pagingOptions.pagesCount += 1 if totalCount % pagingOptions.pageSize > 0
    )
    .filter('range', () ->
      (input, total) ->
        total = parseInt(total) + 1
        for i in [1 ... total]
            input.push(i);
        return input

    )
