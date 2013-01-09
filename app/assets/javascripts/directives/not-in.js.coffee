angular.module('idea-boardy')
  .directive 'notIn', ['$parse'
    ($parse) ->
      require: 'ngModel'
      link: (scope, element, attrs, ngModelCtrl) ->
        ngModelCtrl.$parsers.push (value) ->
          blackList = $parse(attrs.notIn)(scope)
          isValid = not _.contains(blackList, value)
          ngModelCtrl.$setValidity 'duplicated', isValid
          if isValid then value else undefined
  ]
