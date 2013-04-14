define([
    'underscore',
    'views/proto/push-pull',
    'text!templates/like.html'
], function (_, PushPull, html) {
    return PushPull.extend({
        template: _.template(html),
        field: 'likes',
        ownerField: 'user',

        push: function () {
            this.model.like();
        },

        pull: function () {
            this.model.unlike();
        }
    });
});
