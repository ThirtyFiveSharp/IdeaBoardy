(function(){
    var commands = [
        {verb: '+board', tip:"Create A New Board", executor: createBoard },
        {verb: '-board', tip:"Delete A Board", executor: deleteBoard }
    ];

    function createBoard(input) {
        console.log('Create board: ', input);
    }

    function deleteBoard(input) {
        console.log('Delete board: ', input);
    }

    function search(input) {
        console.log('Search for: ', input);
    }

    angular.module('idea-boardy')
        .directive('launchy', ['$window', function($window) {
            return {
                restrict: 'E',
                templateUrl: 'template/launchy.html',
                replace: true,
                scope: {},
                controller: 'LaunchyController',
                link: function(scope, element, attrs) {
                    var commandInput = element.find('.command');
                    angular.element($window).bind('keypress', function(e) {
                        printDebugInfo();
                        if(e.altKey && e.which == 96) {
                            element.show();
                            commandInput.focus();
                        }
                        if(e.keyCode == 27 && e.originalEvent.originalTarget == commandInput[0]) {
                            element.hide();
                            scope.$apply(scope.reset);
                        }

                        function printDebugInfo() {
                            console.log('========key pressed========')
                            console.log(e)
                            console.log(e.originalEvent.originalTarget)
                        }
                    });
                }
            };
        }])
        .controller('LaunchyController', ['$scope', function($scope) {
            var noCommand = {tip: 'Launchy is here!', executor: angular.noop},
                searchCommand = {tip: 'Search for', executor: search};
            $scope.commandToExecute = noCommand;
            $scope.reset = function() {
                $scope.commandToExecute = noCommand;
                $scope.commandInput = null;
            };
            $scope.execute = function() {
                $scope.commandToExecute.executor($scope.parameter);
            };
            $scope.$watch('commandInput', function(commandInput) {
                if(!commandInput) {
                    $scope.commandToExecute = noCommand;
                    return;
                }

                var separatorIndex = commandInput.indexOf(' '),
                    verb = separatorIndex == -1 ? commandInput : commandInput.substr(0, separatorIndex);
                $scope.commandToExecute = _.detect(commands, function(command) { return command.verb.indexOf(verb) === 0; }) || searchCommand;
                $scope.parameter = commandInput.substr(separatorIndex + 1);
            });
        }]);

})();
