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

    .controller('BoardController', ['$scope', '$routeParams', '$resource', '$http',
        function ($scope, $routeParams, $resource, $http) {
            var BoardResource = $resource('/boards/:boardId'),
                board, sections;

            var enhanceBoard = function(board) {
                angular.extend(board, {
                    selfLink: _.find(board.links, function (l) {return l.rel == 'self';}),
                    sectionsLink: _.find(board.links, function (l) {return l.rel == 'sections';}),
                    mode: "view",
                    edit: function() {this.mode = 'edit'},
                    cancel: function() {this.mode = 'view'}
                });
            };

            var enhanceSection = function(section) {
                angular.extend(section, {
                    selfLink: _.find(section.links, function(l) {return l.rel == 'section'}),
                    mode: "view",
                    edit: function() {this.mode = "edit";},
                    cancel: function() {this.mode = "view";}
                });
            };

            board = $scope.board = BoardResource.get({boardId:$routeParams.boardId}, function () {
                enhanceBoard(board);
                $http.get(board.sectionsLink.href).success(function (sections) {
                    $scope.sections = sections;
                    _.each($scope.sections, enhanceSection);
                });
            });
            $scope.edit = function() {
                board.edit();
            };
            $scope.editSection = function(section) {
                section.edit();
            };
        }
    ])

    .controller('EditBoardController', ['$scope', '$http', '$route',
        function($scope, $http, $route) {
            $scope.editingBoard = {};
            angular.copy($scope.board, $scope.editingBoard);
            $scope.cancel = function() {
                $scope.board.cancel();
            };
            $scope.save = function() {
                $http.put($scope.editingBoard.selfLink.href, $scope.editingBoard).success($route.reload);
            };
        }
    ])

    .controller('CreateSectionController', [ '$scope', '$http', '$route',
        function($scope, $http, $route) {
            $scope.section = {};
            $scope.create = function() {
                $http.post($scope.board.sectionsLink.href, $scope.section).success($route.reload);
            };
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

    .controller('EditSectionController', ['$scope', '$http', '$route',
        function($scope, $http, $route) {
            $scope.editingSection = {};
            angular.copy($scope.section, $scope.editingSection);
            $scope.rename = function() {
                $http.put($scope.editingSection.selfLink.href, $scope.editingSection).success($route.reload);
            };
            $scope.delete = function() {
                $http.delete($scope.editingSection.selfLink.href).success($route.reload);
            };
            $scope.cancel = function() {
                $scope.section.cancel();
            };
        }
    ])

    .controller('IdeaController', ['$scope', '$routeParams', '$http',
        function ($scope, $http) {
        }
    ])

;