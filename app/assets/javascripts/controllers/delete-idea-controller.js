angular.module('idea-boardy')
    .controller('DeleteIdeaController', ['$scope', '$http',
    function ($scope, $http) {
        $scope.delete = function() {
            $scope.isDeleteIdeaDialogVisible = false;
            $http.delete($scope.idea.links.getLink('self').href)
                .success(function() {
                    $scope.$emit(ScopeEvent.beginRefreshSection);
                });
        };
        $scope.close = function() {
            $scope.isDeleteIdeaDialogVisible = false;
        };
        $scope.$on(ScopeEvent.deleteIdea, function() {
            $scope.isDeleteIdeaDialogVisible = true;
        });
    }
]);
