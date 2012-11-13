angular.module('idea-boardy')
    .controller('BoardController', ['$scope', '$http', '$location', 'params',
        function ($scope, $http, $location, params) {
            $http.get(params('boardUri')).success(function (board) {
                enhanceBoard(board);
                $scope.board = board;
                $http.get(board.sectionsLink.href).success(function (sections) {
                    $scope.sections = sections;
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
        }
    ]);

