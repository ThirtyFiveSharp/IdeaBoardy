angular.module('idea-boardy')
    .controller('CreateBoardController', ['$scope', '$timeout', 'dialog', 'color',
        function ($scope, $timeout, dialog, color) {
            $scope.dialog = dialog("createBoardDialog");
            $scope.create = function () {
                if ($scope.createBoardForm.$invalid) return;
                $scope.dialog.close();
                $scope.dialog.context.createAll();
            };
            $scope.cancel = function() {
                $scope.dialog.close();
            };
            $scope.addSection = function () {
                var sectionsToCreate = $scope.dialog.context.sectionsToCreate;
                var defaultColor = color(sectionsToCreate.length);
                sectionsToCreate.push({color: defaultColor});
            };
            $scope.removeSection = function (index) {
                $scope.dialog.context.sectionsToCreate[index].name = "(to be removed)";
                $timeout(function () {
                    $scope.dialog.context.sectionsToCreate.splice(index, 1);
                });
            };
            $scope.toggleInvitation = function() {
                $scope.dialog.context.recipients = !!($scope.dialog.context.shouldNotify) ? [{}] : undefined;
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
