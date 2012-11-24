angular.module('idea-boardy')
    .directive('colorPicker', ['colors', function (colors) {
        return {
            restrict:'E',
            templateUrl:'assets/color-picker.html',
            replace:true,
            link: function(scope, element, attrs) {
                var model = scope.$eval(attrs['for']);
                scope.pickColor = function(index) {
                    model.color = colors[index];
                };
                scope.mark = function(index) {
                    return model.color && model.color == colors[index % 6]
                        ? "X"
                        : "";
                };
            }
        }
    }])
;