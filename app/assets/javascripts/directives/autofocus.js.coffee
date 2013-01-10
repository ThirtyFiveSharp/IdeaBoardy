angular.module('idea-boardy')
  .directive 'autofocus', ->
    priority: -1
    link: (scope, element, attrs) -> element.focus()