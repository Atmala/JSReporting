angular.module('formValidation', [])
  .directive('dayDuration', () ->
    return {
      require: 'ngModel'
      link: (scope, elm, attrs, ctrl) ->
        validator =  (viewValue) ->

          prj = scope.reportItem.project

          if (!prj? || prj.toLowerCase() in ['ill', 'vacation','dayoff']) or (viewValue > 0 and viewValue < 25)
            ctrl.$setValidity 'day', true
            return viewValue
          else
            ctrl.$setValidity 'day', false
            return undefined

        ctrl.$formatters.push(validator);
        ctrl.$parsers.unshift(validator);

        scope.$watch 'reportItem.project', (value)->
          validator ctrl.$viewValue

        attrs.$observe('dayDuration', () ->
          validator ctrl.$viewValue
        )
    }
  )