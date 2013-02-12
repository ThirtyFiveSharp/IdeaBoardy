angular.module('m-idea-boardy')
    .controller('MBoardDetailsController', ['$scope', '$http', 'config', 'params',
    function ($scope, $http, config, params) {
        $scope.initialize = function() {
            var boardUri = config.shortenUrlEntryPoint + "/" + params('shortenUrlCode');
            $http.get(boardUri, {params:{embed:"tags,concepts"}}).success(function (board) {
                $scope.board = board;
            });
        };
    }
]);