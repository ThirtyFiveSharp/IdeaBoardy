angular.module('idea-boardy')
    .controller('BoardController', ['$scope', '$http', '$location', 'params', 'dialog', 'color', 'events',
        function ($scope, $http, $location, params, dialog, color, events) {
            var deleteBoardDialog = dialog('deleteBoardDialog'),
                createSectionDialog = dialog('createSectionDialog'),
                createTagDialog = dialog('createTagDialog'),
                editTagDialog = dialog('editTagDialog'),
                deleteTagDialog = dialog('deleteTagDialog');
            $http.get(params('uri')).success(function (board) {
                enhanceBoard(board);
                $scope.board = board;
                refreshSections();
            });

            $scope.showDeleteBoardDialog = function() {
                deleteBoardDialog.open({boardToDelete: $scope.board});
            };
            $scope.showCreateSectionDialog = function() {
                createSectionDialog.open({board: $scope.board, sectionToCreate: {color: color(0)}});
            };
            $scope.showCreateTagDialog = function($event) {
                createTagDialog.open({board: $scope.board, $event: $event});
            };
            $scope.showEditTagDialog = function(tag, $event) {
                editTagDialog.open({board: $scope.board, tagToEdit:_.clone(tag), $event: $event});
            };
            $scope.showDeleteTagDialog = function(tag) {
                deleteTagDialog.open({board: $scope.board, tagToDelete: tag});
            };
            $scope.goToReport = function(board) {
                var reportLinkUri = board.reportLink.href;
                params('uri', reportLinkUri);
                $location.path('report').search({uri: reportLinkUri});
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

            function enhanceBoard(rawBoard) {
                angular.extend(rawBoard, {
                    tags: ["张桐", "ZT", "Zhang Tong"], //TODO: call api to get tags
                    selfLink:rawBoard.links.getLink('self'),
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
                        //TODO: call api to create tag
                    },
                    updateTag: function(tag) {
                        //TODO: call api to update tag
                    },
                    deleteTag: function(tag) {
                        //TODO: call api to delete tag
                    }
                });
            }
            function refreshSections() {
                $http.get($scope.board.sectionsLink.href).success(function (sections) {
                    $scope.sections = sections;
                });
            }
        }
    ]);

