angular.module('idea-boardy')
    .controller('CreateTagController', [ '$scope', 'dialog',
    function ($scope, dialog) {
        $scope.dialog = dialog('createTagDialog');
        $scope.create = function () {
            if($scope.createTagForm.$invalid) return;
            $scope.dialog.close();
            $scope.dialog.context.board.createTag($scope.dialog.context.tagToCreate);
        };
        $scope.cancel = function() {
            $scope.dialog.close();
        };
    }
]);