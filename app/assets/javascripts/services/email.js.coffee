angular.module('idea-boardy')
  .factory('email', ['$http', ($http) ->
    invite: (person, board) ->
      $http.post(board.links.getLink('invitation').href, {to: person, board: board})
    share: (person, board) ->
      $http.post(board.links.getLink('share').href, {to: person, board: board})
  ])