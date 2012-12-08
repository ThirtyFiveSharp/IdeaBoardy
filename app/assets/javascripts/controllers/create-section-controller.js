angular.module('idea-boardy')
    .controller('CreateSectionController', [ '$scope', 'dialog',
        function ($scope, dialog) {
            $scope.dialog = dialog('createSectionDialog');
            $scope.create = function () {
                if($scope.createSectionForm.$invalid) return;
                $scope.dialog.close();
                $scope.dialog.context.board.createSection($scope.dialog.context.sectionToCreate);
            };
            $scope.cancel = function() {
                $scope.dialog.close();
            };
        }
    ]);