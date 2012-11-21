angular.module('idea-boardy')
    .controller('MergeIdeaController', ['$scope', 'dialog',
        function ($scope, dialog) {
            $scope.dialog = dialog('mergeIdeaDialog');
            $scope.save = function() {
                $scope.dialog.close();
                $scope.dialog.context.merge();
            };
            $scope.cancel = function() {
                $scope.dialog.close();
            };
        }
    ]);