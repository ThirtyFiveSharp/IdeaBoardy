angular.module('idea-boardy')
    .controller('DeleteBoardController', ['$scope', '$http', '$location',
        function ($scope, $http, $location) {
            $scope.board = {};
            $scope.delete = function(board) {
                $scope.isDeleteBoardDialogVisible = false;
                $http.delete(board.links.getLink('self').href)
                    .success(function() {
                        $location.path("/");
                    });
            };
            $scope.close = function() {
                $scope.isDeleteBoardDialogVisible = false;
            };
            $scope.$on(ScopeEvent.deleteBoard, function(event, board) {
                $scope.board = board;
                $scope.isDeleteBoardDialogVisible = true;
            });
        }
    ]);
