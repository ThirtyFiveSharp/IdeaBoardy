angular.module('idea-boardy')
  .directive 'colorPicker', ['color', (color) ->
    restrict: 'E'
    templateUrl: 'assets/color-picker.html'
    replace: true
    link: (scope, element, attrs) ->
      scope.pickColor = (index) ->
        model = scope.$eval(attrs['for'])
        model.color = color(index)
      scope.mark = (index) ->
        model = scope.$eval(attrs['for'])
        if model? and model.color is color(index) then "✓" else ""
  ]