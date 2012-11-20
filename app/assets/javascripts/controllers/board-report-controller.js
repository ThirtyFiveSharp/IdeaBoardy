angular.module('idea-boardy')
    .controller('BoardReportController', ['$scope', '$http', 'params', '$location',
    function ($scope, $http, params, $location) {
        $http.get(params('reportUri')).success(function (report) {
            $scope.report = report;
        });
        $scope.goToBoard = function () {
            var newPath = $location.path().replace('/report', '');
            var boardUri = $scope.report.links.getLink('board').href;
            $location.path(newPath).search({boardUri: boardUri});
        };
    }
]);