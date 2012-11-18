angular.module('idea-boardy')
    .controller('CreateSectionController', [ '$scope', 'dialog',
        function ($scope, dialog) {
            $scope.dialog = dialog('createSectionDialog');
            $scope.create = function () {
                if(!$scope.createSectionForm.$valid) return;
                $scope.dialog.close();
                $scope.dialog.params.board.createSection($scope.dialog.params.sectionToCreate);
            };
            $scope.cancel = function() {
                $scope.dialog.close();
            };
        }
    ]);