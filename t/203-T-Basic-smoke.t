#!perl

use strict;
use warnings;
use Test::More;

use Assert::Refute qw(:core);
{
    package Foo;
    use Assert::Refute::T::Basic;
    use Assert::Refute::T::Deep;
}

my $report;

$report = contract {
    package Foo;
    is_deeply {bar => 2}, {foo => 1 };
}->exec;

is $report->count, 1, "is_deeply bad: 1 test run";
ok !$report->is_passing, "is_deeply bad: not passing";
note $report->as_tap;

$report = contract {
    package Foo;
    is_deeply {foo => 1}, {foo => 1 };
}->exec;

is $report->count, 1, "is_deeply good: 1 test run";
ok $report->is_passing, "is_deeply good: passing";

$report = contract {
    package Foo;
    note foo => { x => 42 };
    diag "bared";
}->exec;

like $report->as_tap(2), qr/^## foo \{ *"x" *: *42 *\}/m, "note works";
like $report->as_tap(2), qr/^# bared/m, "diag works";

$report = contract {
    package Foo;
    is 42, 137;
    like "foobar", "f.*b.*r";
}->exec;

is $report->count, 2, "is + like bad: 2 tests run";
ok !$report->is_passing, "is + like bad: not passing";
note $report->as_tap;


done_testing;