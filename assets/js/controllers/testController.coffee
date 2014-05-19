angular.module('test', ['$strap.directives'])
    .controller('testCtrl',($scope) ->
        $scope.td = new Date()
    )