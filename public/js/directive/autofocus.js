angular.module('idea-boardy')
    .directive('autofocus', function () {
        return function (scope, element, attrs) {
            element.focus();
        }
    });

