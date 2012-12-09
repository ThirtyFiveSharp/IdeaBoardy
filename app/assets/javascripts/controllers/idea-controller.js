angular.module('idea-boardy')
    .controller('IdeaController', ['$scope', '$http', 'dialog', 'events',
    function ($scope, $http, dialog, events) {
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
            refreshTags(rawIdea);
            return _.extend(rawIdea, {
                addVote: function() {
                    $http.post(this.links.getLink('vote').href).success(refreshIdea);
                },
                save: function() {
                    $http.put(this.links.getLink('self').href, this).success(refreshIdea);
                },
                delete: function() {
                    $http.delete(this.links.getLink('self').href)
                        .success(function() {
                            $scope.$emit(events.ideaDeleted, $scope.$index);
                        });
                },
                mergeWith: function(sourceIdea) {
                    var destIdea = this;
                    dialog('mergeIdeaDialog').open({
                        mergedIdea: {content: destIdea.content + "\n" + sourceIdea.content},
                        merge: function() {
                            var requestBody = {content: this.mergedIdea.content, source: sourceIdea.id};
                            $http.post(destIdea.links.getLink('merging').href, requestBody)
                                .success(function() {
                                    sourceIdea.notifyEmigrated();
                                    $scope.$emit(events.ideaMerged, sourceIdea);
                                });
                        }
                    });
                },
                notifyEmigrated: function () {
                    $scope.$emit(events.ideaEmigrated);
                },
                addTag: function(tag) {
                    var idea = this,
                        tags = idea.getTags();
                    if(_.contains(this.getTags(), tag)) return;
                    $http.put(idea.links.getLink('tags').href, buildRequestToUpdateTags(tags.concat(tag)))
                        .success(function() {refreshTags(idea)});
                },
                removeTag: function(tag) {
                    var idea = this,
                        tags = idea.getTags(),
                        index = tags.indexOf(tag);
                    if(index < 0) return;
                    tags.splice(index, 1);
                    $http.put(idea.links.getLink('tags').href, buildRequestToUpdateTags(tags))
                        .success(function() {refreshTags(idea)});
                }
            });
        }
        function refreshIdea() {
            $http.get($scope.idea.links.getLink('self').href).success(function (idea) {
                $scope.idea = enhanceIdea(idea);
            });
        }
        function buildRequestToUpdateTags(tags) {
            return {tags: _.map(tags, function(tag) {return tag.id})};
        }
        function refreshTags(idea) {
            $http.get(idea.links.getLink('tags').href)
                .success(function(tagsOfIdea) {
                    idea.tagIds = _.map(tagsOfIdea, function(tagOfIdea) {return tagOfIdea.id;});
                    idea.getTags = function() {
                        return _.select($scope.tags, function(tag) {return _.contains(idea.tagIds, tag.id);});
                    };
                });
        }
    }
]);