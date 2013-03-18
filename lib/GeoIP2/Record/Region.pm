package GeoIP2::Record::Region;

use strict;
use warnings;

use GeoIP2::Types qw( NonNegativeInt PositiveInt Str );

use Moo;

with 'GeoIP2::Role::HasNames';

has confidence => (
    is        => 'ro',
    isa       => NonNegativeInt,
    predicate => 'has_confidence',
);

has geoname_id => (
    is       => 'ro',
    isa      => PositiveInt,
    predicate => 'has_geoname_id,'
);

has iso_3166_2 => (
    is       => 'ro',
    isa      => Str,
    predicate => 'has_iso_3166_2,'
);

1;
