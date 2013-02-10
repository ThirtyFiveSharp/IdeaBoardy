describe('dialog', function () {

    beforeEach(module('idea-boardy-services'));

    it('should re-use same dialog when creating dialog with same name', inject(function (dialog) {
        var dialog1 = dialog('dialog1');
        var dialog2 = dialog('dialog1');
        expect(dialog1).toBe(dialog2);
    }));

    it('should create new dialog when creating dialog with different name', inject(function (dialog) {
        var dialog1 = dialog('dialog1');
        var dialog2 = dialog('dialog2');
        expect(dialog1).not.toBe(dialog2);
    }));

    it('should set dialog visible to true when open dialog', inject(function (dialog) {
        var dialog = dialog('dialog');
        dialog.open();
        expect(dialog.visible).toBeTruthy();
        expect(dialog.context).toEqual({});
    }));

    it('should set default context to {} when open dialog without context object', inject(function (dialog) {
        var dialog = dialog('dialog');
        dialog.open();
        expect(dialog.context).toEqual({});
    }));


    it('should set dialog context to given context when open dialog', inject(function (dialog) {
        var context = {name: 'value'};
        var dialog = dialog('dialog');
        dialog.open(context);
        expect(dialog.context).toBe(context);
    }));

    it('should set dialog visible to false when close dialog', inject(function (dialog) {
        var dialog = dialog('dialog');
        dialog.open();
        dialog.close();
        expect(dialog.visible).toBeFalsy();
    }));
});