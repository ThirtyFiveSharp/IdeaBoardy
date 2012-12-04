angular.module('idea-boardy', ['ui'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/board', {templateUrl:'assets/board.html'});
        $routeProvider.when('/report', {templateUrl:'assets/board-report.html'});
        $routeProvider.otherwise({templateUrl:'assets/board-list.html', controller:'BoardListController'});
    }])
    .config(['$locationProvider', function($locationProvider) {
        $locationProvider.html5Mode(true);
    }])
;