angular.module('idea-boardy')
    .controller('DeleteSectionController', ['$scope', 'dialog',
    function ($scope, dialog) {
        $scope.dialog = dialog('deleteSectionDialog');
        $scope.delete = function() {
            $scope.dialog.close();
            $scope.dialog.context.sectionToDelete.delete();
        };
        $scope.cancel = function() {
            $scope.dialog.close();
        };
    }
]);
