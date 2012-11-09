angular.module('idea-boardy', ['ngResource'])
    .config(['$routeProvider', function($routeProvider){
        $routeProvider.when('/boards/:boardId', {templateUrl: 'template/board.html', controller: 'BoardController'})
        $routeProvider.otherwise({templateUrl: 'template/board-list.html', controller: 'BoardListController'})
    }])

    .controller('BoardListController', ['$scope', '$resource',
        function($scope, $resource) {
            var BoardResource = $resource('/boards/:boardId', {boardId: '@id'});
            $scope.boards = BoardResource.query();
        }
    ])

    .controller('CreateBoardController', ['$scope', '$resource', '$route', '$http',
        function($scope, $resource, $route, $http) {
            var BoardResource = $resource('/boards/:boardId'),
                board = $scope.board = new BoardResource(),
                sections = $scope.sections = [];

            $scope.create = function() {
                board.$save(function(createdBoard, responseHeaders) {
                    var createdBoardUri = responseHeaders('location');
                    $http.get(createdBoardUri).success(function(createdBoard) {
                        var sectionsLink = _.find(createdBoard.links, function(l) {return l.rel == 'sections'});
                        _.each(sections, function(section){
                           $http.post(sectionsLink.href, section);
                        });
                    });
                });
                $route.reload();
            };

            $scope.addSection = function() {
                sections.push({});
            }
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