angular.module('idea-boardy')
    .factory('params', ['$routeParams',
        function ($routeParams) {
            var params = {},
                fresh = true;

            return function (key, value) {
                if (arguments.length == 0) {
                    fresh = false;
                    return _.extend(_.clone(params), $routeParams);
                }
                if (arguments.length == 1) {
                    fresh = false;
                    return $routeParams[key] || params[key];
                }
                if (!fresh) {
                    delete params;
                    params = {};
                    fresh = true;
                }
                params[key] = value;
            };
        }
    ]);