angular.module('idea-boardy')
    .controller('CreateIdeaController', [ '$scope', 'dialog',
    function ($scope, dialog) {
        $scope.dialog = dialog('createIdeaDialog');
        $scope.create = function () {
            if($scope.createIdeaForm.$invalid) return;
            $scope.dialog.close();
            $scope.dialog.context.section.createIdea($scope.dialog.context.ideaToCreate);
        };
        $scope.cancel = function() {
            $scope.dialog.close();
        };
    }
]);