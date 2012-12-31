angular.module('idea-boardy')
    .controller('BoardInvitationController', [ '$scope', 'dialog', 'email', '$timeout',
    function ($scope, dialog, email, $timeout) {
        $scope.dialog = dialog('invitationDialog');
        $scope.create = function () {
            if($scope.invitationForm.$invalid) return;
            $scope.dialog.close();
            var context = $scope.dialog.context;
            var recipients = _.map(context.recipients, function (recipient) {
                return recipient.email;
            });
            email.invite(recipients, context.boardToInvite);
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