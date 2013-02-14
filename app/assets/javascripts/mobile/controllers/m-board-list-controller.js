angular.module('m-idea-boardy')
    .controller('MBoardListController', ['$scope', '$http', 'config',
    function ($scope, $http, config) {
        $scope.initialize = function () {
            $scope.boards = [];
            $http.get(config.apiEntryPoint).success(function (boards) {
                $scope.boards = boards;
            });
        };
    }
]);