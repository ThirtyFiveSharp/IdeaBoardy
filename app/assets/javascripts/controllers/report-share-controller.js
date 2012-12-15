angular.module('idea-boardy')
    .controller('ReportShareController', [ '$scope', 'dialog', 'email',
    function ($scope, dialog, email) {
        $scope.dialog = dialog('shareDialog');
        $scope.share = function () {
            if($scope.shareForm.$invalid) return;
            $scope.dialog.close();
            var context = $scope.dialog.context;
            email.share(context.to, context.reportToShare);
        };
        $scope.cancel = function() {
            $scope.dialog.close();
        };
    }
]);