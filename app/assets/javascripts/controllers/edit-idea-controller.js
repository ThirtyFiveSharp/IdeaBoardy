angular.module('idea-boardy')
    .controller('EditIdeaController', ['$scope', 'dialog',
        function ($scope, dialog) {
            $scope.dialog = dialog('editIdeaDialog');
            $scope.update = function() {
                $scope.dialog.close();
                $scope.dialog.params.ideaToEdit.save();
            };
            $scope.cancel = function() {
                $scope.dialog.close();
            };
        }
    ]);