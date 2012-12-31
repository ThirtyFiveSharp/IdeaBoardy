angular.module('idea-boardy')
    .controller('ReportShareController', [ '$scope', 'dialog', 'email', '$timeout',
    function ($scope, dialog, email, $timeout) {
        $scope.dialog = dialog('shareDialog');
        $scope.share = function () {
            if($scope.shareForm.$invalid) return;
            $scope.dialog.close();
            var context = $scope.dialog.context;
            var recipients = _.map(context.recipients, function (recipient) {
                return recipient.email;
            });
            email.share(recipients, context.boardToShare);
        };
        $scope.cancel = function() {
            $scope.dialog.close();
        };
        $scope.addRecipient = function() {
            var recipients = $scope.dialog.context.recipients;
            recipients.push({});
        };
        $scope.removeRecipient = function (index) {
            $timeout(function () {
                $scope.dialog.context.recipients.splice(index, 1);
            });
        };
    }
]);