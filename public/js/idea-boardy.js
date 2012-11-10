(function() {
    var ideaBoardModule = window.ideaBoardModule = angular.module('idea-boardy', [])
        .config(['$routeProvider', function($routeProvider){
            $routeProvider.when('/boards/:boardId', {templateUrl: 'template/board.html', controller: 'BoardController'})
            $routeProvider.otherwise({templateUrl: 'template/board-list.html', controller: 'BoardListController'})
        }]);

    ideaBoardModule.factory('params', ['$routeParams',
            function($routeParams) {
                var params = {},
                    fresh = true;

                return function(key, value) {
                    if(arguments.length == 0) {
                        fresh = false;
                        return _.extend(_.clone(params), $routeParams);
                    }
                    if(arguments.length == 1) {
                        fresh = false;
                        return $routeParams[key] || params[key];
                    }
                    if(!fresh) {
                        delete params;
                        params = {};
                        fresh = true;
                    }
                    params[key] = value;
                };
            }
        ])

        .controller('BoardListController', ['$scope', '$http', '$location', 'params',
            function($scope, $http, $location, params) {
                $http.get('/boards').success(function(boards) { $scope.boards = boards; });
                $scope.showCreateBoardDialog = function() {
                    console.log('showCreateBoardDialog');
                    $scope.isCreateBoardDialogVisible = true;
                };
                $scope.goToBoard = function(board) {
                    var boardLink = getLink(board.links, 'board');
                    params('boardUri', boardLink.href);
                    $location.path('/boards/'+board.id).search('boardUri', boardLink.href);
                };
            }
        ])

        .controller('CreateBoardController', ['$scope', '$route', '$http', '$timeout',
            function($scope, $route, $http, $timeout) {
                var board = $scope.board = {},
                    sections = $scope.sections = [];

                $scope.create = function() {
                    if(!$scope.createBoardForm.$valid) return;
                    $http.post('/boards', board).success(function(createdBoard, status, headers) {
                        board = $scope.board = {};
                        var createdBoardUri = headers('location');
                        $http.get(createdBoardUri).success(function(createdBoard) {
                            var sectionsLink = getLink(createdBoard.links, 'sections');
                            _.each(sections, function(section){
                               $http.post(sectionsLink.href, section);
                            });
                            $route.reload();
                        });
                    });
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

        .controller('BoardController', ['$scope', '$http', 'params',
            function ($scope, $http, params) {
                $http.get(params('boardUri')).success(function(board) {
                    enhanceBoard(board);
                    $scope.board = board;
                    $http.get(board.sectionsLink.href).success(function (sections) {
                        $scope.sections = sections;
                        _.each($scope.sections, enhanceSection);
                    });
                });

                function enhanceBoard(board) {
                    angular.extend(board, {
                        selfLink: getLink(board.links, 'self'),
                        sectionsLink: getLink(board.links, 'sections'),
                        mode: "view",
                        edit: function() {this.mode = 'edit'},
                        cancel: function() {this.mode = 'view'}
                    });
                }

                function enhanceSection(section) {
                    angular.extend(section, {
                        selfLink: getLink(section.links, 'section'),
                        mode: "view",
                        editable: true,
                        enable: function() {this.editable = true},
                        disable: function() {this.editable = false},
                        edit: function() {
                            _.each($scope.sections, function(section) {
                                section.disable();
                            });
                            this.enable();
                            this.mode = "edit";
                        },
                        cancel: function() {
                            _.each($scope.sections, function(section) {
                                section.enable();
                            });
                            this.mode = "view";
                        }
                    });
                }
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

        .controller('SectionController', ['$scope', '$http',
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

        .directive('jqUi', function() {
            return function(scope, element, attrs) {
                element[attrs.jqUi].apply(element);
            };
        })

        .directive('jqUiDialog', function() {
            return function(scope, element, attrs) {
                var options = JSON.parse(attrs.jqUiDialog || '{}');
                var visibilityExpr = attrs.ngShow;
                var targetElementId = attrs.for;
                element.dialog(_.extend(options, {
                    title: attrs.title,
                    autoOpen: false,
                    modal: true,
                    resizable: false,
//                    width: 400,
                    position: {my: 'center center-50%', at: 'center', of: window},
                    close: function() {
                        scope.$apply(function() {
                            scope[visibilityExpr] = false;
                        });
                    }
                }));
                scope.$watch(visibilityExpr, function(visible){
                    element.dialog(visible ? 'open' : 'close');
                });
            }
        })
    ;

    function getLink(links, rel) {
        var link = _.find(links, function(link) { return link.rel === rel; });
        return link || {rel: null, href: null};
    }
})();
