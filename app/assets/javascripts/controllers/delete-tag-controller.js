angular.module('idea-boardy')
    .controller('DeleteTagController', ['$scope', 'dialog',
        function ($scope, dialog) {
            $scope.dialog = dialog('deleteTagDialog');
            $scope.delete = function() {
                $scope.dialog.close();
                $scope.dialog.context.board.deleteTag($scope.dialog.context.tagToDelete);
            };
            $scope.cancel = function() {
                $scope.dialog.close();
            };
        }
    ]);
