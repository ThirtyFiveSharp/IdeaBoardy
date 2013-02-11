angular.module('m-idea-boardy', ['idea-boardy-services'])
  .value('config', {
    apiEntryPoint: "/api/boards"
  })
  .config(['$routeProvider', ($routeProvider) ->
    $routeProvider.otherwise {templateUrl: '#board_list'}
  ])
  .config(['$locationProvider', ($locationProvider) ->
    $locationProvider.html5Mode true
  ])
;