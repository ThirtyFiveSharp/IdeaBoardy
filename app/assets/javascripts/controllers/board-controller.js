angular.module('idea-boardy')
    .controller('BoardController', ['$scope', '$http', '$location', 'params', 'dialog',
        function ($scope, $http, $location, params, dialog) {
            var deleteBoardDialog = dialog('deleteBoardDialog'),
                createSectionDialog = dialog('createSectionDialog');
            $http.get(params('boardUri')).success(function (board) {
                enhanceBoard(board);
                $scope.board = board;
                refreshSections();
            });

            $scope.showDeleteBoardDialog = function() {
                deleteBoardDialog.open({boardToDelete: $scope.board});
            };
            $scope.showCreateSectionDialog = function() {
                createSectionDialog.open({board: $scope.board, sectionToCreate: {}});
            };
            $scope.goToReport = function(board) {
                var reportLinkUri = board.reportLink.href;
                params('reportUri', reportLinkUri);
                $location.path('report').search({reportUri: reportLinkUri});
            };

            $scope.$on(ScopeEvent.editSection, function(event, targetSection) {
                if(event.stopPropagation) event.stopPropagation();
                if(event.targetScope == $scope) return;
                $scope.$broadcast(ScopeEvent.editSection, targetSection);
            });

            $scope.$on(ScopeEvent.cancelEditSection, function(event, targetSection) {
                if(event.stopPropagation) event.stopPropagation();
                if(event.targetScope == $scope) return;
                $scope.$broadcast(ScopeEvent.cancelEditSection, targetSection);
            });
            $scope.$on(ScopeEvent.sectionDeleted, function(event, index) {
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
                    edit:function () {
                        this.mode = 'edit'
                    },
                    delete:function() {
                        $http.delete(this.links.getLink('self').href).success(function() {
                            $location.path("/").search({});
                        });
                    },
                    createSection: function(sectionToCreate) {
                        $http.post(this.sectionsLink.href, sectionToCreate).success(refreshSections);
                    },
                    cancel:function () {
                        this.mode = 'view'
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

