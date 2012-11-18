angular.module('idea-boardy')
    .controller('DeleteSectionController', ['$scope', 'dialog',
    function ($scope, dialog) {
        $scope.dialog = dialog('deleteSectionDialog');
        $scope.delete = function() {
            $scope.dialog.close();
            $scope.dialog.params.sectionToDelete.delete();
        };
        $scope.cancel = function() {
            $scope.dialog.close();
        };
    }
]);
