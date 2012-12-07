angular.module('idea-boardy')
    .controller('BoardListController', ['$scope', '$http', '$location', 'params', 'dialog', 'config',
        function ($scope, $http, $location, params, dialog, config) {
            var createBoardDialog = dialog('createBoardDialog');
            refreshBoardList();

            $scope.showCreateBoardDialog = function () {
                createBoardDialog.open({
                    boardToCreate: {},
                    sectionsToCreate: [],
                    createAll: function() {
                        var board = this.boardToCreate,
                            sections = this.sectionsToCreate;
                        $http.post(config.apiEntryPoint, board).success(function (createdBoard, status, headers) {
                            var createdBoardUri = headers('location');
                            $http.get(createdBoardUri).success(function (createdBoard) {
                                var sectionsLink = createdBoard.links.getLink('sections');
                                _.each(sections, function (section) {
                                    $http.post(sectionsLink.href, section);
                                });
                                refreshBoardList();
                            });
                        });
                    }
                });
            };
            $scope.goToBoard = function (board) {
                var boardLink = board.links.getLink('board');
                $location.path('/board').search({uri: boardLink.href});
            };

            function refreshBoardList() {
                $http.get(config.apiEntryPoint).success(function (boards) {
                    $scope.boards = boards;
                });
            }
        }
    ]);