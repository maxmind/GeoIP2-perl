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
    is       => 'ro',
    isa      => Num,
    required => 1,
);

has longitude => (
    is       => 'ro',
    isa      => Num,
    required => 1,
);

has metro_code => (
    is       => 'ro',
    isa      => PositiveInt,
    required => 1,
);

has postal_code => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has postal_confidence => (
    is        => 'ro',
    isa       => NonNegativeInt,
    predicate => 'has_postal_confidence',
);

has time_zone => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

1;
