angular.module('idea-boardy')
    .controller('BoardReportController', ['$scope', '$http', 'params', '$location', 'dialog',
    function ($scope, $http, params, $location, dialog) {
        var shareDialog = dialog('shareDialog');
        $http.get(params('uri')).success(function (report) {
            $scope.report = report;
        });
        $scope.showShareDialog = function() {
            shareDialog.open({reportToShare: $scope.report});
        };
        $scope.goToBoard = function () {
            var boardUri = $scope.report.links.getLink('board').href;
            $location.path('/board').search({uri: boardUri});
        };
    }
]);