use lib 'lib';
use Play::Test;
use parent qw(Test::Class);

use Play::DB qw(db);

sub setup :Test(setup) {
    reset_db();
}

sub add :Tests {
    my $quest = db->quests->add({
        name => 'quest name',
        user => 'foo',
        status => 'open',
    });
    cmp_deeply $quest, superhashof({
        _id => re('^\w+$'),
        ts => re('^\d+$'),
        name => 'quest name',
        status => 'open',
        user => 'foo',
        team => ['foo'],
    });
}

sub leave_join :Tests {
    my $quest = db->quests->add({
        name => 'quest name',
        user => 'foo',
        status => 'open',
    });

    like exception { db->quests->leave($quest->{_id}, '') }, qr/only non-empty users can/;
    like exception { db->quests->leave($quest->{_id}, 'bar') }, qr/unable to leave/;
    is exception { db->quests->leave($quest->{_id}, 'foo') }, undef;

    $quest = db->quests->get($quest->{_id});
    is $quest->{user}, '';
    cmp_deeply $quest->{team}, [];

    db->quests->join($quest->{_id}, 'foo');
}

sub join_team :Tests {
    local $TODO = 'team quests not implemented';

    my $quest = db->quests->add({
        name => 'quest name',
        user => 'foo',
        status => 'open',
    });

    is exception { db->quests->join($quest->{_id}, 'bar') }, undef;
    cmp_deeply $quest->{team}, ['foo', 'bar'];
}

sub list :Tests {
    my @data = (
        {
            name => 'q1',
            user => 'foo',
            status => 'open',
        },
        {
            name => 'q2',
            user => 'foo',
            status => 'open',
        },
        {
            name => 'q3',
            user => 'foo',
            status => 'open',
        },
    );
    for (@data) {
        $_->{_id} = db->quests->add($_)->{_id};
    }

    cmp_deeply
        [ sort { $a->{_id} cmp $b->{_id} } @{ db->quests->list({}) } ],
        [ map { superhashof({ %$_, team => [$_->{user}] }) } sort { $a->{_id} cmp $b->{_id} } @data ];
}

sub watch_unwatch :Tests {
    my $quest = db->quests->add({
        name => 'quest name',
        user => 'foo',
        status => 'open',
    });

    like exception { db->quests->watch($quest->{_id}, 'foo') }, qr/unable to watch/;
    like exception { db->quests->unwatch($quest->{_id}, 'foo') }, qr/unable to unwatch/;

    db->quests->watch($quest->{_id}, 'bar');
    db->quests->watch($quest->{_id}, 'baz');
    $quest = db->quests->get($quest->{_id});
    cmp_deeply $quest->{watchers}, [qw( bar baz )];

    db->quests->unwatch($quest->{_id}, 'bar');
    $quest = db->quests->get($quest->{_id});
    cmp_deeply $quest->{watchers}, [qw( baz )];
}

__PACKAGE__->new->runtests;
