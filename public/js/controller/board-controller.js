angular.module('idea-boardy')
    .controller('BoardController', ['$scope', '$http', '$location', 'params',
        function ($scope, $http, $location, params) {
            $http.get(params('boardUri')).success(function (board) {
                enhanceBoard(board);
                $scope.board = board;
                $http.get(board.sectionsLink.href).success(function (sections) {
                    $scope.sections = sections;
                    _.each($scope.sections, enhanceSection);
                });
            });
            $scope.addSection = function() {
                $scope.$broadcast(ScopeEvent.createNewSection);
            };

            function enhanceBoard(board) {
                angular.extend(board, {
                    selfLink:board.links.getLink('self'),
                    sectionsLink:board.links.getLink( 'sections'),
                    mode:"view",
                    edit:function () {
                        this.mode = 'edit'
                    },
                    delete:function() {
                        $scope.$broadcast(ScopeEvent.deleteBoard, this);
                    },
                    cancel:function () {
                        this.mode = 'view'
                    }
                });
            }

            function enhanceSection(section) {
                angular.extend(section, {
                    selfLink:section.links.getLink('section'),
                    mode:"view",
                    editable:true,
                    enable:function () {
                        this.editable = true
                    },
                    disable:function () {
                        this.editable = false
                    },
                    edit:function () {
                        _.each($scope.sections, function (section) {
                            section.disable();
                        });
                        this.enable();
                        this.mode = "edit";
                    },
                    delete:function() {
                        $scope.$broadcast(ScopeEvent.deleteSection, this);
                    },
                    addIdea:function() {
                        $scope.$broadcast(ScopeEvent.createNewIdea, this);
                    },
                    cancel:function () {
                        _.each($scope.sections, function (section) {
                            section.enable();
                        });
                        this.mode = "view";
                    }
                });
            }
        }
    ]);

