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

        function enhanceIdea(rawIdea) {
            return _.extend(rawIdea, {
                addVote: function() {
                    $http.post(this.links.getLink("vote").href).success(refreshIdea);
                },
                save: function() {
                    $http.put(this.links.getLink('self').href, this).success(refreshIdea);
                },
                delete: function() {
                    $http.delete(this.links.getLink('self').href)
                        .success(function() {
                            $scope.$emit(ScopeEvent.ideaDeleted, $scope.$index);
                        });
                }
            });
        }
        function refreshIdea() {
            $http.get($scope.idea.links.getLink('self').href).success(function (idea) {
                $scope.idea = enhanceIdea(idea);
            });
        }
    }
]);