angular.module('idea-boardy')
  .factory('email', ['$http', ($http) ->
    invite: (person, board) ->
      $http.post(board.links.getLink('invitation').href, {to: person, board: board})
    share: (person, report) ->
      $http.post(report.links.getLink('share').href, {to: person, report: report})
  ])