angular.module('idea-boardy')
    .factory('email', ['$http',
    function ($http) {
        return {
            invite:function (person, board) {
                $http.post(board.links.getLink('invitation').href, {to:person, board:board}).success();
            }
        };
    }]);