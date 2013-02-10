describe 'color', ->
  expectColors = ['ddffdd', 'fff0f5', 'e6e6fa', 'ffffe0', 'e0ffff', 'ffefd5']

  beforeEach(module('idea-boardy-services'))

  it 'should return color value of given index', inject (color) ->
    expect(color(i)).toBe(expectedColor) for expectedColor, i in expectColors

  it 'should return round color value of given large index', inject (color) ->
    index = 100
    expect(color(index)).toBe(expectColors[index % expectColors.length])