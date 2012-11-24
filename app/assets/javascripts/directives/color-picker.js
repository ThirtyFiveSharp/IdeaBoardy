angular.module('idea-boardy')
    .directive('colorPicker', ['colors', function (colors) {
        return {
            restrict:'E',
            templateUrl:'assets/color-picker.html',
            replace:true,
            link: function(scope, element, attrs) {
                scope.pickColor = function(index) {
                    var model = scope.$eval(attrs['for']);
                    model.color = colors[index];
                };
                scope.mark = function(index) {
                    var model = scope.$eval(attrs['for']);
                    return model && model.color && model.color == colors[index % 6]
                        ? "X"
                        : "";
                };
            }
        }
    }])
;