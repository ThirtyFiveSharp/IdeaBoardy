angular.module('idea-boardy')
    .controller('EditIdeaController', ['$scope', '$http',
        function ($scope, $http) {
            $scope.editingIdea = {};
            angular.copy($scope.idea, $scope.editingIdea);
            $scope.save = function () {
                $scope.isEditIdeaFormVisible = false;
                $http.put($scope.idea.links.getLink('self').href, $scope.editingIdea)
                    .success(function() {
                        $scope.$emit(ScopeEvent.beginRefreshIdea);
                    });
            };
            $scope.resetEditIdeaForm = function() {
                $scope.editingIdea = {};
                angular.copy($scope.idea, $scope.editingIdea);
            };
            $scope.cancel = function () {
                $scope.isEditIdeaFormVisible = false;
            };

            $scope.$on(ScopeEvent.editIdea, function() {
                $scope.isEditIdeaFormVisible = true;
            });
        }
    ]);