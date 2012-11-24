describe('color', function() {
    var expectColors = ['ddffdd', 'fff0f5', 'e6e6fa', 'ffffe0', 'e0ffff', 'ffefd5'];
    beforeEach(module('idea-boardy'));

    it('should return color value of given index', inject(function(color) {
        for(var i=0;i<6;i++) {
            expect(color(i)).toBe(expectColors[i]);
        }
    }));

    it('should return round color value of given large index', inject(function(color) {
         var index = 100;
        expect(color(index)).toBe(expectColors[index % expectColors.length]);
    }));
});