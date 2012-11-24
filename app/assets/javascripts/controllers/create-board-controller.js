angular.module('idea-boardy')
    .controller('CreateBoardController', ['$scope', '$timeout', 'dialog', 'colors',
        function ($scope, $timeout, dialog, colors) {
            $scope.dialog = dialog("createBoardDialog");
            $scope.create = function () {
                if (!$scope.createBoardForm.$valid) return;
                $scope.dialog.close();
                $scope.dialog.context.createAll();
            };
            $scope.cancel = function() {
                $scope.dialog.close();
            };
            $scope.addSection = function () {
                var defaultColor = colors[$scope.dialog.context.sectionsToCreate.length % 6];
                $scope.dialog.context.sectionsToCreate.push({color: defaultColor});
            };
            $scope.removeSection = function (index) {
                $scope.dialog.context.sectionsToCreate[index].name = "(to be removed)";
                $timeout(function () {
                    $scope.dialog.context.sectionsToCreate.splice(index, 1);
                });
            };
        }
    ]);
