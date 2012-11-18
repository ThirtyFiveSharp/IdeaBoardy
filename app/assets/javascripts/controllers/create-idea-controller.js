angular.module('idea-boardy')
    .controller('CreateIdeaController', [ '$scope', 'dialog',
    function ($scope, dialog) {
        $scope.dialog = dialog('createIdeaDialog');
        $scope.create = function () {
            if(!$scope.createIdeaForm.$valid) return;
            $scope.dialog.close();
            $scope.dialog.params.section.createIdea($scope.dialog.params.ideaToCreate);
        };
        $scope.cancel = function() {
            $scope.dialog.close();
        };
    }
]);