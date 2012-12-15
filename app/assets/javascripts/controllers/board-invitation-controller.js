angular.module('idea-boardy')
    .controller('BoardInvitationController', [ '$scope', 'dialog', '$http',
    function ($scope, dialog, $http) {
        $scope.dialog = dialog('invitationDialog');
        $scope.create = function () {
            if($scope.invitationForm.$invalid) return;
            $scope.dialog.close();
            var context = $scope.dialog.context;
            $http.post(context.boardToInvite.invitationLink.href, {to: context.to, board: context.boardToInvite}).success();
        };
        $scope.cancel = function() {
            $scope.dialog.close();
        };
    }
]);