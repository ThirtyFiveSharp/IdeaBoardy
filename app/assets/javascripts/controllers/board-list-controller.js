angular.module('idea-boardy')
    .controller('BoardListController', ['$scope', '$http', '$location', 'params', 'dialog', 'config', 'email',
    function ($scope, $http, $location, params, dialog, config, email) {
        var createBoardDialog = dialog('createBoardDialog');
        refreshBoardList();

        $scope.showCreateBoardDialog = function () {
            createBoardDialog.open({
                boardToCreate:{},
                sectionsToCreate:[],
                createAll:function () {
                    var me = this,
                        board = me.boardToCreate,
                        sections = me.sectionsToCreate,
                        shouldNotify = me.shouldNotify;
                    $http.post(config.apiEntryPoint, board).success(function (createdBoard, status, headers) {
                        var createdBoardUri = headers('location');
                        $http.get(createdBoardUri).success(function (createdBoard) {
                            var sectionsLink = createdBoard.links.getLink('sections');
                            _.each(sections, function (section) {
                                $http.post(sectionsLink.href, section);
                            });
                            refreshBoardList();
                            if (shouldNotify) {
                                var recipients = _.map(me.recipients, function (recipient) {
                                    return recipient.email;
                                });
                                email.invite(recipients, createdBoard);
                            }
                        });
                    });
                }
            });
        };
        $scope.goToBoard = function (board) {
            $location.path('/board/' + board.shortenUrlCode);
        };

        $scope.filterBoard = function(board) {
            var keyword = $scope.keyword;
            if (!keyword) {
                return board;
            }
            var regexp = new RegExp(keyword, 'gi');
            var name = board.name;
            if (name.match(regexp)) {
                return board;
            }
            return undefined;
        };

        function refreshBoardList() {
            $http.get(config.apiEntryPoint).success(function (boards) {
                $scope.boards = boards;
            });
        }
    }
]);