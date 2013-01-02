angular.module('idea-boardy')
    .controller('BoardReportController', ['$scope', '$http', 'params', '$location', 'dialog', 'autoUpdater',
    function ($scope, $http, params, $location, dialog, autoUpdater) {
        var shareDialog = dialog('shareDialog');
        refreshBoards();
        $scope.showShareDialog = function () {
            shareDialog.open({boardToShare:$scope.board, recipients:[{}]});
        };
        $scope.goToBoard = function () {
            var boardUri = $scope.board.links.getLink('self').href;
            $location.path('/board').search({uri:boardUri});
        };

        function refreshBoards() {
            $http.get(params('uri'), {params:{embed:"sections"}}).success(function (board) {
                $scope.board = board;
                $scope.sections = [];
                _.each($scope.board.sections, function (section) {
                    $http.get(section.links.getLink('self').href, {params:{embed:"ideas"}})
                        .success(function (section) {
                            $scope.sections.push(section);
                        });
                });
            });
        }

        function refreshSections() {
            _.each($scope.sections, function (section, index) {
                $http.get(section.links.getLink('self').href, {params:{embed:"ideas"}})
                    .success(function (section) {
                        $scope.sections[index] = section;
                    });
            });
        }

        autoUpdater.clear();
        autoUpdater.register($location.cur, refreshSections);
    }
]);