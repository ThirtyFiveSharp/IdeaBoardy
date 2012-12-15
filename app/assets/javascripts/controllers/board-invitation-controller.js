angular.module('idea-boardy')
    .controller('BoardInvitationController', [ '$scope', 'dialog', 'email',
    function ($scope, dialog, email) {
        $scope.dialog = dialog('invitationDialog');
        $scope.create = function () {
            if($scope.invitationForm.$invalid) return;
            $scope.dialog.close();
            var context = $scope.dialog.context;
            email.invite(context.to, context.boardToInvite);
        };
        $scope.cancel = function() {
            $scope.dialog.close();
        };
    }
]);