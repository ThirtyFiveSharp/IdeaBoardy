angular.module('m-idea-boardy')
    .controller('MBoardListController', ['$scope', '$http', 'config', '$location',
    function ($scope, $http, config, $location) {
        $http.get(config.apiEntryPoint).success(function (boards) {
            $scope.boards = boards;
        });
        $scope.goToBoard = function (board) {
            $location.path('/board/' + board.shortenUrlCode);
        };
    }
]);