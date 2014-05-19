angular.module('reportData', ['ngResource']).
    factory('TimeReport', ($resource) ->
        return $resource '/timeReport', {id: '@_id'}, {'reportItems': {method: 'GET', isArray: true}}
    )


