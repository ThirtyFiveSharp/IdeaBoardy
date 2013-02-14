angular.module('m-idea-boardy', ['idea-boardy-services'])
  .value('config', {
    apiEntryPoint: "/api/boards"
    shortenUrlEntryPoint: "/url"
  })
  .config(['$routeProvider', ($routeProvider) ->
    $routeProvider.when '/board/:shortenUrlCode', {templateUrl: '#board_details'}
    $routeProvider.when '/board/:shortenUrlCode/addIdea', {templateUrl: '#add_idea'}
    $routeProvider.when '/board/:shortenUrlCode/idea', {templateUrl: '#show_idea'}
    $routeProvider.otherwise {templateUrl: '#board_list'}
  ])
  .config(['$locationProvider', ($locationProvider) ->
    $locationProvider.html5Mode true
  ])
;