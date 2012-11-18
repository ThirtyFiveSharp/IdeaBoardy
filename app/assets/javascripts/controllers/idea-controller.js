angular.module('idea-boardy')
    .controller('IdeaController', ['$scope', '$http', 'dialog',
    function ($scope, $http, dialog) {
        var editIdeaDialog = dialog('editIdeaDialog'),
            deleteIdeaDialog = dialog('deleteIdeaDialog');
        $http.get($scope.idea.links.getLink('idea').href).success(function (idea) {
            $scope.idea = enhanceIdea(idea);
        });
        $scope.showEditDialog = function($event) {
            editIdeaDialog.open({ideaToEdit: _.clone($scope.idea), $event: $event});
        };
        $scope.showDeleteDialog = function() {
            deleteIdeaDialog.open({ideaToDelete: $scope.idea});
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
                save: function() {
                    var idea = this;
                    $http.put(idea.links.getLink('self').href, idea)
                        .success(function() {
                            $scope.$emit(ScopeEvent.beginRefreshIdea);
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