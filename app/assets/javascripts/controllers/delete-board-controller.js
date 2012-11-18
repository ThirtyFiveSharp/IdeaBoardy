angular.module('idea-boardy')
    .controller('DeleteBoardController', ['$scope', 'dialog',
        function ($scope, dialog) {
            $scope.dialog = dialog('deleteBoardDialog');
            $scope.delete = function() {
                $scope.dialog.close();
                $scope.dialog.context.boardToDelete.delete();
            };
            $scope.close = function() {
                $scope.dialog.close();
            };
        }
    ]);
