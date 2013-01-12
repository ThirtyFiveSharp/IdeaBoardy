angular.module('idea-boardy', ['ui'])
  .value('config', {apiEntryPoint: "/api/boards"})
  .value('i18n', {
    required: 'Please provide a value for this field.'
    email: 'Please provide a valid email address.'
  })
  .config(['$routeProvider', ($routeProvider) ->
    $routeProvider.when '/board', {templateUrl: 'assets/board.html'}
    $routeProvider.when '/report', {templateUrl: 'assets/board-report.html'}
    $routeProvider.otherwise {templateUrl: 'assets/board-list.html', controller: 'BoardListController'}
  ])
  .config(['$locationProvider', ($locationProvider) ->
    $locationProvider.html5Mode true
  ])