(function() {
    angular.module('idea-boardy', ['ngResource'])
        .config(['$routeProvider', function($routeProvider){
            $routeProvider.when('/boards/:boardId', {templateUrl: 'template/board.html', controller: 'BoardController'})
            $routeProvider.otherwise({templateUrl: 'template/board-list.html', controller: 'BoardListController'})
        }])

        .controller('BoardListController', ['$scope', '$http',
            function($scope, $http) {
                $http.get('/boards').success(function(boards) { $scope.boards = boards; });
            }
        ])

        .controller('CreateBoardController', ['$scope', '$route', '$http', '$timeout',
            function($scope, $route, $http, $timeout) {
                var board = $scope.board = {},
                    sections = $scope.sections = [];

                $scope.create = function() {
                    if(!$scope.createBoardForm.$valid) return;
                    $http.post('/boards', board).success(function(createdBoard, status, headers) {
                        var createdBoardUri = headers('location');
                        $http.get(createdBoardUri).success(function(createdBoard) {
                            var sectionsLink = getLink(createdBoard.links, 'sections');
                            _.each(sections, function(section){
                               $http.post(sectionsLink.href, section);
                            });
                        });
                    });
                    $route.reload();
                };

                $scope.addSection = function () {
                    sections.push({});
                }

                $scope.removeSection = function(index) {
                    sections[index].name = "(to be removed)";
                    $timeout(function() {
                        sections.splice(index, 1);
                    });
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
                $http.get(getLink($scope.section.links, 'ideas').href)
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

        .directive('autofocus', function() {
            return function(scope, element, attrs) {
                element.focus();
            }
        })

        .directive('errorMessage', function(){
            return function(scope, element, attrs) {
                var associatedElement = element.prev(),
                    ngModel = associatedElement.controller('ngModel');
                if(!ngModel) return;

                element.addClass('error-message');
                ngModel.$parsers.push(function(viewValue) {
                    if(ngModel.$dirty) {
                        var keys = _.keys(ngModel.$error),
                            errorKeys = _.filter(keys, function(key) {return ngModel.$error[key];});
                        element.text(errorKeys.join(' '));
                    }
                    return viewValue;
                });
            };
        })
    ;

    function getLink(links, rel) {
        var link = _.find(links, function(link) { return link.rel === rel; });
        return link || {rel: null, href: null};
    }
})();
