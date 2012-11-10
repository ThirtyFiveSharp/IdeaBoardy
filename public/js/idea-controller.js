ideaBoardModule.controller('IdeaController', ['$scope', '$http',
    function ($scope, $http) {
        $http.get(getLink($scope.section.links, 'section').href).success(function (section) {
            $http.get(getLink(section.links, 'ideas').href).success(function (ideas) {
                $scope.ideas = ideas;
            });
        });
    }
]);

function getLink(links, rel) {
    var link = _.find(links, function(link) { return link.rel === rel; });
    return link || {rel: null, href: null};
}