angular.module('idea-boardy')
    .controller('BoardReportController', ['$scope', '$http', '$location', 'config', 'params', 'dialog', 'autoUpdater',
    function ($scope, $http, $location, config, params, dialog, autoUpdater) {
        var shareDialog = dialog('shareDialog');
        refreshBoards();
        $scope.showShareDialog = function () {
            shareDialog.open({boardToShare:$scope.board, recipients:[{}]});
        };
        $scope.goToBoard = function () {
            $location.path('/board/' + $scope.board.shortenUrlCode);
        };

        function refreshBoards() {
            $http.get(config.shortenUrlEntryPoint + "/" + params('shortenUrlCode'), {params:{embed:"sections"}})
                .success(function (board) {
                    $scope.board = board;
                    $scope.sections = [];
                    _.each($scope.board.sections, function (section, index) {
                        $http.get(section.links.getLink('self').href, {params:{embed:"ideas"}})
                            .success(function (section) {
                                $scope.sections[index] = section;
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