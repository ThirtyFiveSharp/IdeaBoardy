angular.module('m-idea-boardy')
    .controller('MIdeaCreateController', ['$scope', '$http', '$location', 'config', 'params',
    function ($scope, $http, $location, config, params) {
        $scope.initialize = function () {
            var boardUri = config.shortenUrlEntryPoint + "/" + params('shortenUrlCode');
            $http.get(boardUri, {params:{embed:"sections"}})
                .success(function (board) {
                    $scope.board = board;
                    $scope.owningSection = board.sections[0];
                });
            $scope.ideaToCreate = {};
        };
        $scope.cancel = function () {
            $location.path('/board/' + $scope.board.shortenUrlCode);
        };
        $scope.create = function (ideaToCreate) {
            $http.post($scope.owningSection.links.getLink('ideas').href, ideaToCreate)
                .success(function () {
                    $location.path('/board/' + $scope.board.shortenUrlCode);
                });
        };
    }
]);