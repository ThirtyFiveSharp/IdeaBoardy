angular.module('idea-boardy')
    .controller('CreateIdeaController', [ '$scope', '$http', '$route',
    function ($scope, $http, $route) {
        $scope.idea = {};
        $scope.resetCreateIdeaForm = function() {
            $scope.idea = {};
        };
//        $scope.create = function () {
//            if(!$scope.createSectionForm.$valid) return;
//            $scope.isCreateSectionFormVisible = false;
//            $http.post($scope.board.sectionsLink.href, $scope.section).success($route.reload);
//        };
        $scope.cancel = function() {
            $scope.isCreateIdeaFormVisible = false;
        };
        $scope.$on(ScopeEvent.createNewIdea, function() {
            $scope.isCreateIdeaFormVisible = true;
        });
    }
]);