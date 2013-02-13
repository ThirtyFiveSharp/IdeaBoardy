angular.module('m-idea-boardy', ['idea-boardy-services'])
  .value('config', {
    apiEntryPoint: "/api/boards"
    shortenUrlEntryPoint: "/url"
  })
  .config(['$routeProvider', ($routeProvider) ->
    $routeProvider.when '/board/:shortenUrlCode', {templateUrl: '#board_details', jqmOptions: {transition: 'slide'}}
    $routeProvider.when '/board/:shortenUrlCode/addIdea', {templateUrl: '#add_idea', jqmOptions: {transition: 'slide'}}
    $routeProvider.otherwise {templateUrl: '#board_list'}
  ])
  .config(['$locationProvider', ($locationProvider) ->
    $locationProvider.html5Mode true
  ])
;