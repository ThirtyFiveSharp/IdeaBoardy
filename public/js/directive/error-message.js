angular.module('idea-boardy')
    .directive('errorMessage', function () {
        return function (scope, element, attrs) {
            var associatedElement = element.prev(),
                ngModel = associatedElement.controller('ngModel');
            if (!ngModel) return;

            element.addClass('error-message');
            ngModel.$parsers.push(function (viewValue) {
                if (ngModel.$dirty) {
                    var keys = _.keys(ngModel.$error),
                        errorKeys = _.filter(keys, function (key) {
                            return ngModel.$error[key];
                        });
                    element.text(errorKeys.join(' '));
                }
                return viewValue;
            });
        };
    });