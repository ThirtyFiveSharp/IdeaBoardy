angular.module('idea-boardy', ['ngResource'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.when('/boards/:boardId', {templateUrl:'template/board.html', controller:'BoardController'})
        $routeProvider.otherwise({templateUrl:'template/board-list.html', controller:'BoardListController'})
    }])

    .controller('BoardListController', ['$scope', '$resource',
        function ($scope, $resource) {
            var BoardResource = $resource('/boards/:boardId', {boardId:'@id'});
            $scope.boards = BoardResource.query();
        }
    ])

    .controller('CreateBoardController', ['$scope', '$resource', '$route', '$http',
        function ($scope, $resource, $route, $http) {
            var BoardResource = $resource('/boards/:boardId'),
                board = $scope.board = new BoardResource(),
                sections = $scope.sections = [];

            $scope.create = function () {
                board.$save(function (createdBoard, responseHeaders) {
                    var createdBoardUri = responseHeaders('location');
                    $http.get(createdBoardUri).success(function (createdBoard) {
                        var sectionsLink = _.find(createdBoard.links, function (l) {
                            return l.rel == 'sections'
                        });
                        _.each(sections, function (section) {
                            $http.post(sectionsLink.href, section);
                        });
                    });
                });
                $route.reload();
            };

            $scope.addSection = function () {
                sections.push({});
            }
        }
    ])

    .controller('SectionController', ['$scope', '$routeParams', '$http',
        function ($scope, $http) {
            $http({method:'GET', url:getLink($scope.section.links, 'ideas')})
                .success(function (ideas) {
                    $scope.ideas = ideas;
                });
        }
    ])

    .controller('IdeaController', ['$scope', '$routeParams', '$http',
        function ($scope, $http) {
        }
    ])

    .controller('BoardController', ['$scope', '$routeParams', '$resource', '$http', '$route',
        function ($scope, $routeParams, $resource, $http, $route) {
            var BoardResource = $resource('/boards/:boardId'),
                board, sections;
            $scope.section = {};
            board = $scope.board = BoardResource.get({boardId:$routeParams.boardId}, function () {
                var sectionsLink = _.find(board.links, function (l) {
                    return l.rel == 'sections'
                });
                $http.get(sectionsLink.href).success(function (sections) {
                    $scope.sections = sections;
                });
                $scope.createSection = function() {
                   $http.post(sectionsLink.href, $scope.section).success(function() {
                       $route.reload();
                   });
                };
            });
            $scope.deleteSection = function(section) {
                var sectionLink = _.find(section.links, function(l) {return l.rel == 'section'});
                $http.delete(sectionLink.href).success(function() {
                    $route.reload();
                });
            };
        }
    ])

;


function getLink(links, rel) {
    var link = _.find(links,
        function (link) {
            return link.rel === rel;
        }).href;
    return link.href;
}
