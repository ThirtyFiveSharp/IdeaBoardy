angular.module('idea-boardy')
    .factory('color', [function() {
        var colors = ['ddffdd', 'fff0f5', 'e6e6fa', 'ffffe0', 'e0ffff', 'ffefd5'];
        return function(index) {
           return colors[index % colors.length];
        };
    }]);