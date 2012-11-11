angular.module('idea-boardy')
    .controller('CreateSectionController', [ '$scope', '$http', '$route',
        function ($scope, $http, $route) {
            $scope.section = {};
            $scope.resetCreateBoardForm = function() {
                $scope.section = {};
            };
            $scope.create = function () {
                if(!$scope.createSectionForm.$valid) return;
                $scope.isCreateSectionFormVisible = false;
                $http.post($scope.board.sectionsLink.href, $scope.section).success($route.reload);
            };
            $scope.$on(ScopeEvent.createNewSection, function() {
                $scope.isCreateSectionFormVisible = true;
            });
        }
    ]);