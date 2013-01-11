angular.module('idea-boardy')
    .controller('SpecifyTagController', [ '$scope', 'dialog',
    function ($scope, dialog) {
        $scope.dialog = dialog('specifyTagDialog');
        $scope.save = function () {
            var tagNames = _.map($scope.dialog.context.tagNames, function(obj) {return obj.text;});
            if($scope.specifyTagForm.$invalid) return;
            $scope.dialog.close();
            $scope.dialog.context.idea.saveTags(tagNames);
        };
        $scope.cancel = function() {
            $scope.dialog.close();
        };
    }
]);