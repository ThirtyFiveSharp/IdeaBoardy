angular.module('idea-boardy')
    .controller('BoardReportController', ['$scope', '$http', 'params',
        function($scope, $http, params) {
           $http.get(params('reportUri')).success(function(report) {
               $scope.report = report;
           });
        }
    ]);