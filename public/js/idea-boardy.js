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
            $scope.reload = function() {$route.reload();};
            $scope.mode = "view";
            $scope.section = {};
            board = $scope.board = BoardResource.get({boardId:$routeParams.boardId}, function () {
                $scope.title = board.name;
                angular.extend(board, {
                    selfLink: _.find(board.links, function (l) {
                        return l.rel == 'self';
                    }),
                    sectionsLink: _.find(board.links, function (l) {
                        return l.rel == 'sections';
                    })
                });
                $http.get(board.sectionsLink.href).success(function (sections) {
                    $scope.sections = sections;
                    _.each($scope.sections, function(section) {
                        angular.extend(section, {
                            mode: "view",
                            edit: function() {this.mode = "edit";},
                            cancel: function() {this.mode = "view";}
                        });
                    });
                });
            });
            $scope.edit = function() {
                $scope.mode = "edit";
            };
            $scope.cancel = function() {
                $scope.mode = "view";
            };
            $scope.save = function() {
                $http.put(board.selfLink.href, $scope.board).success(reload);
            };
            $scope.editSection = function(section) {
                section.edit();
            };
            $scope.createSection = function() {
                $http.post(board.sectionsLink.href, $scope.section).success($route.reload);
            };
        }
    ])

    .controller('EditSectionController', ['$scope', '$http', '$route',
        function($scope, $http, $route) {
            $scope.editingSection = {};
            angular.copy($scope.section, $scope.editingSection);
            var sectionLink = _.find($scope.editingSection.links, function(l) {return l.rel == 'section'});
            $scope.rename = function() {
                $http.put(sectionLink.href, $scope.editingSection).success($route.reload);
            };
            $scope.delete = function() {
                $http.delete(sectionLink.href).success($route.reload);
            };
            $scope.cancel = function() {
                $scope.section.cancel();
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
