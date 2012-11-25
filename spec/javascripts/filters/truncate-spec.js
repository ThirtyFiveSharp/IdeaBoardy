describe("truncate", function () {
    var truncate;

    beforeEach(module('idea-boardy'));

    beforeEach(inject(function($filter) {
        truncate = $filter('truncate');
    }));

    it('should not truncate text less than given max length', function(){
        var text = "8letters";
        var result = truncate(text, 9);
        expect(result).toEqual(text);
    });

    it('should not truncate text equal to given max length', function(){
        var text = "8letters";
        var result = truncate(text, 8);
        expect(result).toEqual(text);
    });

    it('should truncate text greater than given max length', function(){
        var text = "8letters";
        var result = truncate(text, 5);
        expect(result).toEqual('8lett...');
    });
});