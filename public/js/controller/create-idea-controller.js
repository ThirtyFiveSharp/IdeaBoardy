angular.module('idea-boardy')
    .controller('CreateIdeaController', [ '$scope', '$http',
    function ($scope, $http) {
        console.log('CreateIdeaController')
        $scope.idea = {};
        $scope.resetCreateIdeaForm = function() {
            $scope.idea = {};
        };
        $scope.create = function () {
            if(!$scope.createIdeaForm.$valid) return;
            $scope.isCreateIdeaFormVisible = false;
            $http.post($scope.section.links.getLink('ideas').href, $scope.idea)
                .success(function() {
                    $scope.$emit(ScopeEvent.beginRefreshSection);
                });
        };
        $scope.cancel = function() {
            $scope.isCreateIdeaFormVisible = false;
        };
        $scope.$on(ScopeEvent.createNewIdea, function() {
            $scope.isCreateIdeaFormVisible = true;
        });
    }
]);