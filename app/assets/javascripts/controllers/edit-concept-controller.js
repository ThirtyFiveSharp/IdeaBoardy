angular.module('idea-boardy')
    .controller('EditConceptController', [ '$scope', 'dialog',
    function ($scope, dialog) {
        $scope.dialog = dialog('editConceptDialog');
        $scope.save = function () {
            if($scope.editConceptForm.$invalid) return;
            $scope.dialog.close();
            $scope.dialog.context.concept.update($scope.dialog.context.tagNames);
        };
        $scope.delete = function() {
            $scope.dialog.close();
            $scope.dialog.context.concept.delete();
        };
        $scope.cancel = function() {
            $scope.dialog.close();
        };
    }
]);