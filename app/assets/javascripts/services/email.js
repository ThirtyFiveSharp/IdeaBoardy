angular.module('idea-boardy')
    .factory('email', ['$http',
    function ($http) {
        return {
            invite:function (person, board) {
                $http.post(board.links.getLink('invitation').href, {to:person, board:board});
            },
            share: function (person, report) {
                $http.post(report.links.getLink('share').href, {to:person, report:report});
            }
        };
    }]);