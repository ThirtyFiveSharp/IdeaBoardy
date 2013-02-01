angular.module('m-idea-boardy', [])
  .value('config', {
    apiEntryPoint: "/api/boards"
  })
  .config(['$routeProvider', ($routeProvider) ->
    $routeProvider.otherwise {templateUrl: '/assets/m-board-list.html', controller: 'MBoardListController'}
  ])
  .config(['$locationProvider', ($locationProvider) ->
    $locationProvider.html5Mode true
  ])
;