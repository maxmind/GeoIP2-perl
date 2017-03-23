package GeoIP2::Role::Record::Country;

use strict;
use warnings;

our $VERSION = '2.003005';

use Moo::Role;

use GeoIP2::Types qw( NonNegativeInt PositiveInt Str );

use namespace::clean;

with 'GeoIP2::Role::Record::HasNames';

has iso_code => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_iso_code',
);

has geoname_id => (
    is        => 'ro',
    isa       => PositiveInt,
    predicate => 'has_geoname_id',
);

has confidence => (
    is        => 'ro',
    isa       => NonNegativeInt,
    predicate => 'has_confidence',
);

1;
