describe('params', function () {
    beforeEach(module('idea-boardy-services'));

    it('should get parameter value', inject(function (params) {
        params('key', 'value');
        expect(params('key')).toBe('value');
    }));

    it('should set parameter value', inject(function (params) {
        expect(params('key')).toBeUndefined();
        params('key', 'value');
        expect(params('key')).toBe('value');
    }));

    it('should override parameter value', inject(function (params) {
        params('key', 'value1');
        params('key', 'value2');
        expect(params('key')).toBe('value2');
    }));
});