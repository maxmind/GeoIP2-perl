package GeoIP2::Record::Country;

use strict;
use warnings;

use GeoIP2::Types qw( NonNegativeInt PositiveInt Str );

use Moo;

with 'GeoIP2::Role::HasNames';

has iso_3166_1_alpha_2 => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_iso_3166_1_alpha_2',
);

has iso_3166_1_alpha_3 => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_iso_3166_1_alpha_3',
);

has geoname_id => (
    is        => 'ro',
    isa       => PositiveInt,
    predicate => 'has_geoname_id,'
);

has confidence => (
    is        => 'ro',
    isa       => NonNegativeInt,
    predicate => 'has_confidence',
);

1;
