angular.module('idea-boardy', [])
    .config(['$routeProvider', function($routeProvider){
        $routeProvider.when('/boards/:boardId', {templateUrl: 'template/board.html', controller: 'BoardController'})
        $routeProvider.otherwise({templateUrl: 'template/board-list.html', controller: 'BoardListController'})
    }])

    .controller('BoardListController', ['$scope',
        function($scope) {
            $scope.board = "We are boards!";
        }
    ])

    .controller('BoardController', ['$scope', '$routeParams',
        function($scope, $routeParams) {
            $scope.board = "I'm board " + $routeParams.boardId;
        }
    ])

;