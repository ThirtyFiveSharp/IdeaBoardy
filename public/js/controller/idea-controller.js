angular.module('idea-boardy')
    .controller('IdeaController', ['$scope', '$http',
    function ($scope, $http) {
        $http.get($scope.idea.links.getLink('idea').href).success(function (idea) {
            $scope.idea = enhanceIdea(idea);
        });
        $scope.showEditDialog = function() {
            $scope.$broadcast(ScopeEvent.editIdea);
        };
        $scope.showDeleteDialog = function() {
            $scope.$broadcast(ScopeEvent.deleteIdea);
        };

        $scope.$on(ScopeEvent.beginRefreshIdea, function(event) {
            if(event.stopPropagation) event.stopPropagation();
            $scope.$broadcast(ScopeEvent.refresh);
        });
        $scope.$on(ScopeEvent.refresh, function () {
            $http.get($scope.idea.links.getLink('self').href).success(function (idea) {
                $scope.idea = enhanceIdea(idea);
            });
        });

        function enhanceIdea(idea) {
            return _.extend(idea, {
                addVote: function() {
                    $http.post(idea.links.getLink("vote").href).success(function() {
                        $scope.$broadcast(ScopeEvent.refresh);
                    });
                }
            });
        }
    }
]);