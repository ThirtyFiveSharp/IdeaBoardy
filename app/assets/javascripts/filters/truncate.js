angular.module('idea-boardy')
    .filter('truncate', function () {
        return function (input, maxLength) {
            if(!maxLength) {
                maxLength = 100;
            }
            if (input.length <= maxLength) {
                return input;
            }
            return input.substring(0, maxLength) + "...";
        };
    });