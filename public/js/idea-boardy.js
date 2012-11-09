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


    .controller('SectionController', ['$scope', '$routeParams', '$http',
        function($scope, $http) {

        }])
    .controller('IdeaController', ['$scope', '$routeParams', '$http',
        function($scope, $routeParams, $http) {

        }])
    .controller('BoardController', ['$scope', '$routeParams', '$http',
        function($scope, $routeParams, $http) {
            var sectionsLink,
                board = $scope.board = {};

            $http({method:'GET', url:'http://localhost:3000/boards/' + $routeParams.boardId})
                .success(function (board) {
                    sectionsLink = getlink(board, 'sections');
                });

            $scope.$watch(function () {
                return sectionsLink;
            }, function () {
                if (sectionsLink) {
                    $http({method:'GET', url: sectionsLink})
                        .success(function (sections) {
                            board.sections = sections
                        });
                }
            });

            function getlink(boardEntity, rel) {
                return _.find(boardEntity.links,
                    function (link) {
                        return link.rel === rel;
                    }).href;
            }
        }
    ])

;