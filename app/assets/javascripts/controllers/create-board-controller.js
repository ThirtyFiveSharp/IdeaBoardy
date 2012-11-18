angular.module('idea-boardy')
    .controller('CreateBoardController', ['$scope', '$timeout', 'dialog',
        function ($scope, $timeout, dialog) {
            $scope.dialog = dialog("createBoardDialog");
            $scope.create = function () {
                if (!$scope.createBoardForm.$valid) return;
                $scope.dialog.close();
                $scope.dialog.params.createAll();
            };
            $scope.cancel = function() {
                $scope.dialog.close();
            };
            $scope.addSection = function () {
                $scope.dialog.params.sectionsToCreate.push({});
            };
            $scope.removeSection = function (index) {
                $scope.dialog.params.sectionsToCreate[index].name = "(to be removed)";
                $timeout(function () {
                    $scope.dialog.params.sectionsToCreate.splice(index, 1);
                });
            };
        }
    ]);
