angular.module('idea-boardy')
    .controller('AddTagController', [ '$scope', 'dialog',
    function ($scope, dialog) {
        $scope.dialog = dialog('addTagDialog');
        $scope.addTags = function () {
            if($scope.addTagForm.$invalid) return;
            $scope.dialog.close();
            $scope.dialog.context.idea.addTagByNames($scope.dialog.context.tagNames);
        };
        $scope.cancel = function() {
            $scope.dialog.close();
        };
    }
]);