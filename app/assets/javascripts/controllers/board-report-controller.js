angular.module('idea-boardy')
    .controller('BoardReportController', ['$scope', '$http', 'params', '$location', 'dialog',
    function ($scope, $http, params, $location, dialog) {
        var shareDialog = dialog('shareDialog');
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
        $scope.showShareDialog = function () {
            shareDialog.open({boardToShare:$scope.board, recipients:[{}]});
        };
        $scope.goToBoard = function () {
            var boardUri = $scope.board.links.getLink('self').href;
            $location.path('/board').search({uri:boardUri});
        };
    }
]);