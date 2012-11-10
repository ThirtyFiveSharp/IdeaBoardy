angular.module('idea-boardy')
    .controller('BoardListController', ['$scope', '$http', '$location', 'params',
        function ($scope, $http, $location, params) {
            $http.get('/boards').success(function (boards) {
                $scope.boards = boards;
            });
            $scope.createNewBoard = function () {
                $scope.$broadcast(ScopeEvent.createNewBoard);
            };
            $scope.goToBoard = function (board) {
                var boardLink = board.links.getLink('board');
                params('boardUri', boardLink.href);
                $location.path('/boards/' + board.id).search('boardUri', boardLink.href);
            };
        }
    ]);