angular.module('idea-boardy')
    .controller('BoardController', ['$scope', '$http', '$location', 'params', 'dialog', 'color', 'events', 'autoUpdater',
    function ($scope, $http, $location, params, dialog, color, events, autoUpdater) {
        var tagsInBoard = [],
            tagsInConcepts = [],
            deleteBoardDialog = dialog('deleteBoardDialog'),
            createSectionDialog = dialog('createSectionDialog'),
            createTagDialog = dialog('createTagDialog'),
            editTagDialog = dialog('editTagDialog'),
            deleteTagDialog = dialog('deleteTagDialog'),
            deleteIdeaDialog = dialog('deleteIdeaDialog'),
            deleteSectionDialog = dialog('deleteSectionDialog'),
            invitationDialog = dialog('invitationDialog');
        autoUpdater.clear();
        $http.get(params('uri'), {params:{embed:"tags,concepts"}})
            .success(function (board) {
                enhanceBoard(board);
                $scope.board = board;
                tagsInBoard = board.tags;
                tagsInConcepts = groupTagsWithConcepts(board.concepts, board.tags);
                refreshSections();
                autoUpdater.register($scope.board.selfLink.href, refreshTags);
            });

        $scope.showDeleteBoardDialog = function () {
            deleteBoardDialog.open({boardToDelete:$scope.board});
        };
        $scope.showCreateSectionDialog = function () {
            createSectionDialog.open({board:$scope.board, sectionToCreate:{color:color(0)}});
        };
        $scope.showCreateTagDialog = function ($event) {
            createTagDialog.open({board:$scope.board, tagToCreate:{}, $event:$event});
        };
        $scope.showEditTagDialog = function (tag, $event) {
            editTagDialog.open({board:$scope.board, tagToEdit:_.clone(tag), $event:$event});
        };
        $scope.showInvitationDialog = function () {
            invitationDialog.open({boardToInvite:$scope.board, recipients:[
                {}
            ]});
        };
        $scope.showDeleteTagDialog = function (tag) {
            deleteTagDialog.open({board:$scope.board, tagToDelete:tag});
        };
        $scope.showDeleteIdeaDialog = function (idea) {
            deleteIdeaDialog.open({ideaToDelete:idea});
        };
        $scope.showDeleteSectionDialog = function (section) {
            deleteSectionDialog.open({sectionToDelete:section});
        };
        $scope.showConceptDialog = function (concept, tag) {
            if(_.any(concept.tags, function(tagInConcept) { return tagInConcept.id == tag.id; })) return;
            console.log('showConceptDialog: ', concept, tag);
        };
        $scope.goToReport = function (board) {
            $location.path('report').search({uri:board.selfLink.href});
        };
        $scope.getTags = function () {
            return tagsInBoard;
        };
        $scope.getTagsInConcepts = function () {
            return tagsInConcepts;
        };

        $scope.$on(events.editSection, function (event, targetSection) {
            if (event.stopPropagation) event.stopPropagation();
            if (event.targetScope == $scope) return;
            $scope.$broadcast(events.editSection, targetSection);
        });

        $scope.$on(events.sectionEditingFinished, function (event, targetSection) {
            if (event.stopPropagation) event.stopPropagation();
            if (event.targetScope == $scope) return;
            $scope.$broadcast(events.sectionEditingFinished, targetSection);
        });

        $scope.$on(events.sectionDeleted, function (event, index) {
            if (event.stopPropagation) event.stopPropagation();
            clearRegisteredUpdaters();
            $scope.sections.splice(index, 1);
            refreshSections();
        });

        function clearRegisteredUpdaters() {
            _.each($scope.sections, function (section) {
                autoUpdater.unregister(section.links.getLink('section').href);
            });
        }

        $scope.$on(events.tagCreated, function (event) {
            if (event.stopPropagation) event.stopPropagation();
            refreshTags();
        });

        function enhanceBoard(rawBoard) {
            angular.extend(rawBoard, {
                selfLink:rawBoard.links.getLink('self'),
                invitationLink:rawBoard.links.getLink('invitation'),
                tagsLink:rawBoard.links.getLink('tags'),
                sectionsLink:rawBoard.links.getLink('sections'),
                mode:"view",
                selectedSectionName:"",
                edit:function () {
                    this.mode = 'edit'
                },
                delete:function () {
                    $http.delete(this.links.getLink('self').href).success(function () {
                        $location.path("").search({});
                    });
                },
                createSection:function (sectionToCreate) {
                    $http.post(this.sectionsLink.href, sectionToCreate).success(refreshSections);
                },
                cancel:function () {
                    this.mode = 'view'
                },
                isSectionVisible:function (section) {
                    return !this.selectedSectionName || section.name == this.selectedSectionName;
                },
                sectionClass:function () {
                    return !this.selectedSectionName ? 'narrow-rectangle' : 'wide-rectangle'
                },
                createTag:function (tag) {
                    $http.post($scope.board.tagsLink.href, tag).success(refreshTags);
                },
                updateTag:function (tag) {
                    $http.put(tag.links.getLink('self').href, tag).success(refreshTags);
                },
                deleteTag:function (tag) {
                    $http.delete(tag.links.getLink('self').href).success(refreshTags);
                }
            });
        }

        function groupTagsWithConcepts(concepts, tags) {
            var tagsInConcept = _.filter(tags, function (tag) {
                    return !!tag.links.getLink('concept').href;
                }),
                tagsNotInConcept = _.filter(tags, function (tag) {
                    return !tag.links.getLink('concept').href;
                }),
                tagsGroupedByConcept = _.groupBy(tagsInConcept, function (tag) {
                    return tag.links.getLink('concept').href;
                }),
                conceptWithTags = _.map(_.keys(tagsGroupedByConcept), function (conceptUri) {
                    var concept = _.find(concepts, function (c) {
                        return conceptUri === c.links.getLink('self').href
                    });
                    return _.extend(concept, {tags:tagsGroupedByConcept[conceptUri]});
                }),
                sortedConceptsWithTags = _.sortBy(conceptWithTags, function (mergedConcept) {
                    return mergedConcept.name;
                }),
                fakeConceptsWithTags = _.map(tagsNotInConcept, function (tag) {
                    return {name:tag.name, tags:[tag], isFake: true};
                });
            return sortedConceptsWithTags.concat(fakeConceptsWithTags);
        }

        function refreshTags() {
            $http.get($scope.board.selfLink.href, {params:{embed:'tags,concepts'}}).success(function (board) {
                tagsInBoard = board.tags;
                tagsInConcepts = groupTagsWithConcepts(board.concepts, board.tags);
            });
        }

        function refreshSections() {
            $http.get($scope.board.sectionsLink.href).success(function (sections) {
                $scope.sections = sections;
            });
        }
    }
]);

