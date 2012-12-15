angular.module('idea-boardy')
    .controller('BoardController', ['$scope', '$http', '$location', 'params', 'dialog', 'color', 'events',
        function ($scope, $http, $location, params, dialog, color, events) {
            var tagsInBoard = [],
                deleteBoardDialog = dialog('deleteBoardDialog'),
                createSectionDialog = dialog('createSectionDialog'),
                createTagDialog = dialog('createTagDialog'),
                editTagDialog = dialog('editTagDialog'),
                deleteTagDialog = dialog('deleteTagDialog'),
                invitationDialog = dialog('invitationDialog');
            $http.get(params('uri')).success(function (board) {
                enhanceBoard(board);
                $scope.board = board;
                refreshTags();
                refreshSections();
            });

            $scope.showDeleteBoardDialog = function() {
                deleteBoardDialog.open({boardToDelete: $scope.board});
            };
            $scope.showCreateSectionDialog = function() {
                createSectionDialog.open({board: $scope.board, sectionToCreate: {color: color(0)}});
            };
            $scope.showCreateTagDialog = function($event) {
                createTagDialog.open({board: $scope.board, tagToCreate:{}, $event: $event});
            };
            $scope.showEditTagDialog = function(tag, $event) {
                editTagDialog.open({board: $scope.board, tagToEdit:_.clone(tag), $event: $event});
            };
            $scope.showInvitationDialog = function() {
                invitationDialog.open({boardToInvite: $scope.board});
            };
            $scope.showDeleteTagDialog = function(tag) {
                deleteTagDialog.open({board: $scope.board, tagToDelete: tag});
            };
            $scope.goToReport = function(board) {
                var reportLinkUri = board.reportLink.href;
                params('uri', reportLinkUri);
                $location.path('report').search({uri: reportLinkUri});
            };
            $scope.getTags = function() {
                return tagsInBoard;
            };

            $scope.$on(events.editSection, function(event, targetSection) {
                if(event.stopPropagation) event.stopPropagation();
                if(event.targetScope == $scope) return;
                $scope.$broadcast(events.editSection, targetSection);
            });

            $scope.$on(events.sectionEditingFinished, function(event, targetSection) {
                if(event.stopPropagation) event.stopPropagation();
                if(event.targetScope == $scope) return;
                $scope.$broadcast(events.sectionEditingFinished, targetSection);
            });
            $scope.$on(events.sectionDeleted, function(event, index) {
                if(event.stopPropagation) event.stopPropagation();
                $scope.sections.splice(index, 1);
                refreshSections();
            });
            $scope.$on(events.tagCreated, function(event) {
                if(event.stopPropagation) event.stopPropagation();
                refreshTags();
            });

            function enhanceBoard(rawBoard) {
                angular.extend(rawBoard, {
                    selfLink:rawBoard.links.getLink('self'),
                    invitationLink:rawBoard.links.getLink('invitation'),
                    tagsLink:rawBoard.links.getLink('tags'),
                    sectionsLink:rawBoard.links.getLink('sections'),
                    reportLink:rawBoard.links.getLink('report'),
                    mode:"view",
                    selectedSectionName: "",
                    edit:function () {
                        this.mode = 'edit'
                    },
                    delete:function() {
                        $http.delete(this.links.getLink('self').href).success(function() {
                            $location.path("").search({});
                        });
                    },
                    createSection: function(sectionToCreate) {
                        $http.post(this.sectionsLink.href, sectionToCreate).success(refreshSections);
                    },
                    cancel:function () {
                        this.mode = 'view'
                    },
                    isSectionVisible: function(section) {
                        return !this.selectedSectionName || section.name == this.selectedSectionName;
                    },
                    sectionClass: function() {
                        return !this.selectedSectionName ? 'narrow-rectangle' : 'wide-rectangle'
                    },
                    createTag: function(tag) {
                        $http.post($scope.board.tagsLink.href, tag).success(refreshTags);
                    },
                    updateTag: function(tag) {
                        $http.put(tag.links.getLink('tag').href, tag).success(refreshTags);
                    },
                    deleteTag: function(tag) {
                        $http.delete(tag.links.getLink('tag').href).success(refreshTags);
                    }
                });
            }
            function refreshTags() {
                $http.get($scope.board.tagsLink.href).success(function (tags) {
                    tagsInBoard = tags;
                });
            }
            function refreshSections() {
                $http.get($scope.board.sectionsLink.href).success(function (sections) {
                    $scope.sections = sections;
                });
            }
        }
    ]);

