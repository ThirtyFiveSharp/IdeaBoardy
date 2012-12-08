angular.module('idea-boardy')
    .controller('EditTagController', ['$scope', 'dialog',
        function ($scope, dialog) {
            $scope.dialog = dialog('editTagDialog');
            $scope.update = function() {
                $scope.dialog.close();
                $scope.dialog.context.board.updateTag($scope.dialog.context.tagToEdit);
            };
            $scope.cancel = function() {
                $scope.dialog.close();
            };
        }
    ]);