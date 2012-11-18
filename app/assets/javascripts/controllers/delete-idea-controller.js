angular.module('idea-boardy')
    .controller('DeleteIdeaController', ['$scope',
    function ($scope) {
        $scope.delete = function() {
            $scope.isDeleteIdeaDialogVisible = false;
            $scope.ideaToDelete.delete();
        };
        $scope.close = function() {
            $scope.isDeleteIdeaDialogVisible = false;
        };
        $scope.$on(ScopeEvent.deleteIdea, function(event, ideaToDelete) {
            $scope.ideaToDelete = ideaToDelete;
            $scope.isDeleteIdeaDialogVisible = true;
        });
    }
]);
