define([
    'models/event',
    'jasmine-jquery'
], function (EventModel) {
    describe('model/event', function () {

        describe('name', function () {

            var model;
            var modelParams = {
                "object" : {
                    "body" : "body text",
                    "quest" : {
                        "_id" : "517629ce5c6a12cf78000002",
                        "status" : "open",
                        "ts" : 1366698446,
                        "name" : "Прочитать Эрнста и Янга про университеты будущего http://www.ey.com/Publication/vwLUAssets/University_of_the_future/$FILE/University_of_the_future_2012.pdf",
                        "author" : "anykeen",
                        "tags" : [],
                        "watchers" : [
                            "ideali"
                        ],
                        "realm" : "chaos",
                        "likes" : [
                            "berekuk",
                            "ideali"
                        ],
                        "team" : [
                            "anykeen"
                        ]
                    },
                    "author" : "berekuk",
                    "quest_id" : "517629ce5c6a12cf78000002"
                },
                "object_type" : "comment",
                "ts" : 1367856619,
                "_id" : "5187d5eb9174e8db1000001f",
                "author" : "berekuk",
                "realm" : "chaos",
                "action" : "add",
                "object_id" : "5187d5eb9174e8db1000001e"
            };
            beforeEach(function () {
                model = new EventModel(modelParams);
            });

            it('name', function () {
                expect(
                    model.name()
                ).toEqual(
                    'add-comment'
                );
            });
        });
    });
});
