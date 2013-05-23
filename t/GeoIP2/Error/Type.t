use Test::More tests => 2;

use GeoIP2::Error::Type;
use Try::Tiny;

try {
    thrower();
}
catch {
    is( $_->type,  'foo', 'correct type thrown' );
    is( $_->value, 'bar', 'correct value thrown' );
};

sub thrower {
    GeoIP2::Error::Type->throw(
        message => "x is not y",
        type    => 'foo',
        value   => 'bar',
    );
}
