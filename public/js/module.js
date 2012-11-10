angular.module('idea-boardy', [])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/boards/:boardId', {templateUrl:'template/board.html', controller:'BoardController'})
        $routeProvider.otherwise({templateUrl:'template/board-list.html', controller:'BoardListController'})
    }]);