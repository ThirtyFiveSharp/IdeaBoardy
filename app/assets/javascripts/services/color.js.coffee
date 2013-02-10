angular.module('idea-boardy-services')
  .factory 'color', () ->
    colors = ['ddffdd', 'fff0f5', 'e6e6fa', 'ffffe0', 'e0ffff', 'ffefd5']
    (input) ->
      if angular.isNumber(input) then colors[input % colors.length] else colors.indexOf(input)