angular.module('idea-boardy')
    .controller('DeleteIdeaController', ['$scope', 'dialog',
    function ($scope, dialog) {
        $scope.dialog = dialog('deleteIdeaDialog');
        $scope.delete = function() {
            $scope.dialog.close();
            $scope.dialog.params.ideaToDelete.delete();
        };
        $scope.cancel = function() {
            $scope.dialog.close();
        };
    }
]);
