#!perl

use strict;
use warnings;
use Test::More tests => 5;
use Assert::Refute::T::Errors;

{
    package Foo;
    use Assert::Refute { on_pass => 'carp', on_fail => 'croak' };
    package Bar;
    use Assert::Refute { on_pass => 'croak', on_fail => '' };
}

dies_like {
    package Foo;
    carp_refute {
        is 42, 137, "This shall NOT be in the output";
        diag " *** IF YOU SEE THIS, TESTS ARE FAILING";
    };
} qr/not ok 1.*1..1.*Contract failed/s, "Fatal refuted";

warns_like {
    package Foo;
    carp_refute {
        is 42, 42, "This shall NOT be in the output";
        diag " *** IF YOU SEE THIS, TESTS ARE FAILING";
    };
} qr/ok 1.*1..1.*Contract passed/s, "Fatal holds";

dies_like {
    package Bar;
    carp_refute {
        is 42, 42, "This shall NOT be in the output";
        diag " *** IF YOU SEE THIS, TESTS ARE FAILING";
    };
} qr/ok 1.*1..1.*Contract passed/s, "Different setup in another package";

warns_like {
    dies_like {
        package Bar;
        carp_refute {
            is 42, 137, "This shall NOT be in the output";
            diag " *** IF YOU SEE THIS, TESTS ARE FAILING";
        };
    } '', "Silent - no die";
} '', "Silent - no warn";

