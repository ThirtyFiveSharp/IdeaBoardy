angular.module('idea-boardy')
    .controller('BoardController', ['$scope', '$http', '$location', 'params', 'dialog', 'color', 'events',
        function ($scope, $http, $location, params, dialog, color, events) {
            var deleteBoardDialog = dialog('deleteBoardDialog'),
                createSectionDialog = dialog('createSectionDialog');
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
                    selfLink:rawBoard.links.getLink('self'),
                    sectionsLink:rawBoard.links.getLink('sections'),
                    reportLink:rawBoard.links.getLink('report'),
                    mode:"view",
                    selectedSection: undefined,
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
                        return !this.selectedSection || section == this.selectedSection;
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

