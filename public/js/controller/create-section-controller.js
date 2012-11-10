angular.module('idea-boardy')
    .controller('CreateSectionController', [ '$scope', '$http', '$route',
        function ($scope, $http, $route) {
            $scope.section = {};
            $scope.create = function () {
                $http.post($scope.board.sectionsLink.href, $scope.section).success($route.reload);
            };
        }
    ]);