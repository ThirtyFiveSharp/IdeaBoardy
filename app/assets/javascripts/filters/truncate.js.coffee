angular.module('idea-boardy')
  .filter('truncate', () ->
    (input, maxLength) ->
      maxLength = 100 if !maxLength
      return input if input.length <= maxLength
      return input.substring(0, maxLength) + "..."
  )