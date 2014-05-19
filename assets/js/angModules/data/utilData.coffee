angular.module('utilData', ['ngResource']).
  factory('GuidelinesData', ($resource) ->
    return [{'illDaysCount':'5'}, {'vacationDaysCount':'20'}]
    #return $resource('/timeReport', {id: '@_id'}, {'reportItems': {method: 'GET', isArray: true}})
  )
  .factory('WorkTypes', ($resource) ->
    return ['Dev', 'PM', 'UB_Training']
  )
  .factory('Projects', ($resource) ->
    return ['TD-Projects', 'TheProjects', 'SimpleSet.com', 'JSReporting', 'Ill', 'Vacation', 'Day off' ];
  )