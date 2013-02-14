angular.module('m-idea-boardy')
    .controller('MIdeaController', ['$scope', '$http', '$location', 'config', 'params',
    function ($scope, $http, $location, config, params) {
        $scope.initialize = function () {
            $scope.board = {};
            $scope.idea = {};
            var boardUri = config.shortenUrlEntryPoint + "/" + params('shortenUrlCode');
            $http.get(boardUri).success(function (board) {
                $scope.board = board;
            });
            $http.get(params('uri')).success(function (idea) {
                $scope.idea = idea;
            });
        };
        $scope.save = function (idea) {
            $http.put($scope.idea.links.getLink('self').href, idea).success(function () {
                $location.path('/board/' + $scope.board.shortenUrlCode);
            });
        };
        $scope.delete = function(idea) {
            $http.delete(idea.links.getLink('self').href).success(function() {
                $location.path('/board/' + $scope.board.shortenUrlCode);
            });
        };
    }
]);