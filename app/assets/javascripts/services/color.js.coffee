angular.module('idea-boardy')
  .factory 'color', () ->
    colors = ['ddffdd', 'fff0f5', 'e6e6fa', 'ffffe0', 'e0ffff', 'ffefd5']
    (index) -> colors[index % colors.length]