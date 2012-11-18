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
            $scope.$broadcast(ScopeEvent.deleteIdea, $scope.idea);
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

        function enhanceIdea(rawIdea) {
            return _.extend(rawIdea, {
                addVote: function() {
                    var idea = this;
                    $http.post(idea.links.getLink("vote").href).success(function() {
                        $scope.$broadcast(ScopeEvent.refresh);
                    });
                },
                delete: function() {
                    var idea = this;
                    $http.delete(idea.links.getLink('self').href)
                        .success(function() {
                            $scope.$emit(ScopeEvent.beginRefreshSection);
                        });
                }
            });
        }
    }
]);