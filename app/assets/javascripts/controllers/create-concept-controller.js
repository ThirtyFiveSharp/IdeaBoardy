angular.module('idea-boardy')
    .controller('CreateConceptController', [ '$scope', 'dialog',
    function ($scope, dialog) {
        $scope.dialog = dialog('createConceptDialog');
        $scope.create = function () {
            if($scope.createConceptForm.$invalid) return;
            $scope.dialog.close();
            $scope.dialog.context.board.createConcept($scope.dialog.context.conceptName, $scope.dialog.context.tagNames);
        };
        $scope.cancel = function() {
            $scope.dialog.close();
        };
    }
]);