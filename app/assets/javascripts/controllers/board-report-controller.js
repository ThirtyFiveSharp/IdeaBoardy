angular.module('idea-boardy')
    .controller('BoardReportController', ['$scope', '$http', 'params', '$location',
    function ($scope, $http, params, $location) {
        $http.get(params('uri')).success(function (report) {
            $scope.report = report;
        });
        $scope.goToBoard = function () {
            var boardUri = $scope.report.links.getLink('board').href;
            $location.path('/board').search({uri: boardUri});
        };
    }
]);