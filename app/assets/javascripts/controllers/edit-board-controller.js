angular.module('idea-boardy')
    .controller('EditBoardController', ['$scope', '$http', '$route',
        function ($scope, $http, $route) {
            $scope.editingBoard = {};
            angular.copy($scope.board, $scope.editingBoard);
            $scope.cancel = function () {
                $scope.board.cancel();
            };
            $scope.save = function () {
                $http.put($scope.editingBoard.selfLink.href, $scope.editingBoard).success($route.reload);
            };
        }
    ]);