angular.module('idea-boardy')
    .controller('EditSectionController', ['$scope', '$http', '$route',
        function ($scope, $http, $route) {
            $scope.editingSection = {};
            angular.copy($scope.section, $scope.editingSection);
            $scope.rename = function () {
                $http.put($scope.editingSection.selfLink.href, $scope.editingSection).success($route.reload);
            };
            $scope.delete = function () {
                $http.delete($scope.editingSection.selfLink.href).success($route.reload);
            };
            $scope.cancel = function () {
                $scope.section.cancel();
            };
        }
    ]);