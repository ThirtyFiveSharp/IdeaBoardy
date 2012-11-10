Array.prototype.getLink = function(rel) {
    var link = _.find(this, function (link) {
        return link.rel === rel;
    });
    return link || {rel:null, href:null};
};
