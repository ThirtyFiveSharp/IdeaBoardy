angular.module('idea-boardy')
    .controller('EditSectionController', ['$scope', '$http', '$route',
        function ($scope, $http, $route) {
            $scope.editingSection = {};
            angular.copy($scope.section, $scope.editingSection);
            $scope.save = function () {
                $scope.section.save($scope.editingSection);
            };
            $scope.cancel = function () {
                $scope.section.cancel();
            };
        }
    ]);