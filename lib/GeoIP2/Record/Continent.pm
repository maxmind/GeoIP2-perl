package GeoIP2::Record::Continent;

use strict;
use warnings;

use GeoIP2::Types qw( PositiveInt Str );

use Moo;

with 'GeoIP2::Role::HasNames';

has continent_code => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_continent_code',
);

has geoname_id => (
    is        => 'ro',
    isa       => PositiveInt,
    predicate => 'has_geoname_id,'
);

1;
