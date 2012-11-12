angular.module('idea-boardy')
    .controller('EditSectionController', ['$scope', '$http', '$route',
        function ($scope, $http, $route) {
            $scope.editingSection = {};
            angular.copy($scope.section, $scope.editingSection);
            $scope.save = function () {
                $http.put($scope.editingSection.selfLink.href, $scope.editingSection).success($route.reload);
            };
            $scope.cancel = function () {
                $scope.section.cancel();
            };
        }
    ]);