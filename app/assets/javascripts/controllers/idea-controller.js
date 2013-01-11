angular.module('idea-boardy')
    .controller('IdeaController', ['$scope', '$http', '$q', 'dialog', 'events',
    function ($scope, $http, $q, dialog, events) {
        var editIdeaDialog = dialog('editIdeaDialog'),
            specifyTagDialog = dialog('specifyTagDialog');
        $scope.idea = enhanceIdea($scope.idea);
        enhanceIdeaTags($scope.idea, $scope.idea.tags);
        $scope.showEditDialog = function($event) {
            editIdeaDialog.open({ideaToEdit: _.clone($scope.idea), $event: $event});
        };
        $scope.showSpecifyTagDialog = function($event) {
            specifyTagDialog.open({idea: $scope.idea, tagNames: $scope.idea.tagNames || [], allTagNames:$scope.getAllTagNames(), $event: $event});
        };

        function enhanceIdea(rawIdea) {
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
                tagsName: function() {
                    return _.reduce(this.getTags(), function(memo, tag) {return memo + "," + tag.name}, "");
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
                saveTags: function(tagNames) {
                    var idea = this,
                        allTagsOfBoard = $scope.getTags(),
                        allTagNamesOfBoard = _.map(allTagsOfBoard, function(tag) {return tag.name;}),
                        existingTags = _.filter(allTagsOfBoard, function(tag) {return _.contains(tagNames, tag.name);}),
                        tagNamesToCreate = _.filter(tagNames, function(tagName) {return !_.contains(allTagNamesOfBoard, tagName);}),
                        createNewTagPromises = _.map(tagNamesToCreate, function(tagName) {
                            return $http.post($scope.board.tagsLink.href, {name: tagName});
                        }),
                        newlyCreatedTags = [];
                    $q.all(createNewTagPromises).then(function(returns) {
                        _.each(returns, function(obj) {
                            newlyCreatedTags.push(obj.data);
                        });
                        var allTagsOfIdea = existingTags.concat(newlyCreatedTags);
                        $http.put(idea.links.getLink('tags').href, buildRequestToUpdateTags(allTagsOfIdea))
                            .success(function() {
                                if(newlyCreatedTags.length > 0) {
                                    $scope.$emit(events.tagCreated);
                                }
                                refreshTags(idea);
                            });
                    });
                }
            });
        }

        function buildRequestToUpdateTags(tags) {
            return {tags: _.map(tags, function(tag) {return tag.id})};
        }

        function refreshIdea() {
            $http.get($scope.idea.links.getLink('self').href).success(function (idea) {
                $scope.idea = enhanceIdea(idea);
                refreshTags(idea);
            });
        }
        function enhanceIdeaTags(idea, tagsOfIdea) {
            idea.tagIds = _.map(tagsOfIdea, function (tagOfIdea) {
                return tagOfIdea.id;
            });
            idea.tagNames = _.map(tagsOfIdea, function (tagOfIdea) {
                return tagOfIdea.name;
            });
            idea.getTags = function () {
                var tagsNotInConcept = $scope.getTagsNotInConcept(),
                    tagsGroupedByConcept = $scope.getTagsInConcept(),
                    tagsInConcept = [];
                _.each(tagsGroupedByConcept, function(concept) {Array.prototype.push.apply(tagsInConcept, concept.tags)});
                return _.filter(tagsInConcept.concat(tagsNotInConcept), function (tag) {return _.contains(idea.tagIds, tag.id);});
            };
        }

        function refreshTags(idea) {
            $http.get(idea.links.getLink('tags').href)
                .success(function(tagsOfIdea) {
                    enhanceIdeaTags(idea, tagsOfIdea);
                });
        }
    }
]);