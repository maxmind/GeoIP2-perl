package GeoIP2::Record::Location;

use strict;
use warnings;

use GeoIP2::Types qw( NonNegativeInt Num PositiveInt Str );

use Moo;

has accuracy_radius => (
    is        => 'ro',
    isa       => PositiveInt,
    predicate => 'has_accuracy_radius',
);

has latitude => (
    is        => 'ro',
    isa       => Num,
    predicate => 'has_latitude',
);

has longitude => (
    is       => 'ro',
    isa      => Num,
    predicate => 'has_longitude',
);

has metro_code => (
    is        => 'ro',
    isa       => PositiveInt,
    predicate => 'has_metro_code',
);

has postal_code => (
    is       => 'ro',
    isa      => Str,
    predicate => 'has_postal_code',
);

has postal_confidence => (
    is        => 'ro',
    isa       => NonNegativeInt,
    predicate => 'has_postal_confidence',
);

has time_zone => (
    is       => 'ro',
    isa      => Str,
    predicate => 'has_time_zone',
);

1;
