angular.module('idea-boardy-services')
  .factory('params', ['$routeParams', ($routeParams) ->
    params = {}
    fresh = true
    clear = () ->
      params = {}
      fresh = true
    (key, value) ->
      fresh = false if arguments.length <= 1
      return _.extend(_.clone(params), $routeParams) if arguments.length is 0
      return $routeParams[key] || params[key] if arguments.length is 1
      clear if !fresh
      params[key] = value
  ])