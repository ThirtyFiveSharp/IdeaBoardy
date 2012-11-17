angular.module('idea-boardy', [])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/boards/:boardId', {templateUrl:'assets/board.html'})
        $routeProvider.otherwise({templateUrl:'assets/board-list.html', controller:'BoardListController'})
    }]);