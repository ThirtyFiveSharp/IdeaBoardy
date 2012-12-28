angular.module('idea-boardy')
  .directive 'autofocus', ->
    (scope, element, attrs) -> element.focus()