angular.module('idea-boardy')
    .controller('IdeaController', ['$scope', '$http', '$q', 'dialog', 'events',
    function ($scope, $http, $q, dialog, events) {
        var editIdeaDialog = dialog('editIdeaDialog'),
            addTagDialog = dialog('addTagDialog');
        $http.get($scope.idea.links.getLink('idea').href).success(function (idea) {
            $scope.idea = enhanceIdea(idea);
        });
        $scope.showEditDialog = function($event) {
            editIdeaDialog.open({ideaToEdit: _.clone($scope.idea), $event: $event});
        };
        $scope.showAddTagDialog = function($event) {
            addTagDialog.open({idea: $scope.idea, tagNames: [], $event: $event});
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
                },
                addTagByNames: function(tagNames) {
                    var idea = this,
                        tagNamesToAdd = _.filter(tagNames, function(tagName) {return idea.tagNames.indexOf(tagName) < 0});
                    if(tagNamesToAdd.length == 0) return;

                    var allTagsOfBoard = $scope.getTags(),
                        allTagNamesOfBoard = _.map(allTagsOfBoard, function(tag) {return tag.name;}),
                        existingTagsToAdd = _.filter(allTagsOfBoard, function(tag) {return tagNamesToAdd.indexOf(tag.name) >= 0}),
                        newlyCreatedTagsToAdd = [],
                        tagNamesToCreate = _.filter(tagNamesToAdd, function(tagName) {return allTagNamesOfBoard.indexOf(tagName) < 0;}),
                        createNewTagPromises = _.map(tagNamesToCreate, function(tagName) {
                            return $http.post($scope.board.tagsLink.href, {name: tagName});
                        });
                    $q.all(createNewTagPromises).then(function(returns) {
                        _.each(returns, function(obj) {
                            newlyCreatedTagsToAdd.push(obj.data);
                        });
                        var allTagsOfIdea = idea.getTags().concat(existingTagsToAdd).concat(newlyCreatedTagsToAdd);
                        $http.put(idea.links.getLink('tags').href, buildRequestToUpdateTags(allTagsOfIdea))
                            .success(function() {
                                if(newlyCreatedTagsToAdd.length > 0) {
                                    $scope.$emit(events.tagCreated);
                                }
                                refreshTags(idea);
                            });
                    });
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
                    idea.tagNames = _.map(tagsOfIdea, function(tagOfIdea) {return tagOfIdea.name;});
                    idea.getTags = function() {
                        return _.select($scope.getTags(), function(tag) {return _.contains(idea.tagIds, tag.id);});
                    };
                });
        }
    }
]);