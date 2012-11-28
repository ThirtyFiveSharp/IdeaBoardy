angular.module('idea-boardy', [])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/board', {templateUrl:'assets/board.html'});
        $routeProvider.when('/report', {templateUrl:'assets/board-report.html'});
        $routeProvider.otherwise({templateUrl:'assets/board-list.html', controller:'BoardListController'});
    }])
    .run(function($document) {
        $document.tooltip({ position: { my: "left-50 center", at: "right center" } });
    })
;