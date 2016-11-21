use strict;
use warnings;

use Test::Fatal qw( success );
use Test::More 0.88;

use GeoIP2::Error::Type;
use Try::Tiny;

## no critic (TryTiny::RequireBlockTermination)
try {
    thrower();
}
catch {
    is( $_->type,  'foo', 'correct type thrown' );
    is( $_->value, 'bar', 'correct value thrown' );
}
success {
    fail('Expected an exception');
};

sub thrower {
    GeoIP2::Error::Type->throw(
        message => 'x is not y',
        type    => 'foo',
        value   => 'bar',
    );
}

done_testing();
