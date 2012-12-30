angular.module('idea-boardy')
  .directive 'whenBlur', ['$parse', '$rootScope'
    ($parse, $rootScope) ->
      link: (scope, element, attrs) ->
        element.bind 'blur', (event) ->
          params = Array.prototype.slice.call(arguments);
          $parse(attrs.whenBlur)(scope, {$event: event, $params: params})
          scope.$apply() unless $rootScope.$$phase?
  ]
