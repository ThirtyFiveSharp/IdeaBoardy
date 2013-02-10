angular.module('idea-boardy', ['ui', 'idea-boardy-services'])
  .value('config', {
    apiEntryPoint: "/api/boards"
    shortenUrlEntryPoint: "/url"
  })
  .value('i18n', {
    required: 'Please provide a value for this field.'
    email: 'Please provide a valid email address.'
  })
  .config(['$routeProvider', ($routeProvider) ->
    $routeProvider.when '/board/:shortenUrlCode', {templateUrl: '/assets/board.html'}
    $routeProvider.when '/report/:shortenUrlCode', {templateUrl: '/assets/board-report.html'}
    $routeProvider.otherwise {templateUrl: '/assets/board-list.html', controller: 'BoardListController'}
  ])
  .config(['$locationProvider', ($locationProvider) ->
    $locationProvider.html5Mode true
  ])
  .run(['$rootScope', 'autoUpdater', ($rootScope, autoUpdater) ->
    $rootScope.$on('$routeChangeStart', () -> autoUpdater.clear())
  ])
;