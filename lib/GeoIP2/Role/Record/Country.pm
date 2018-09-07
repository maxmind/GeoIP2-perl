package GeoIP2::Role::Record::Country;

use strict;
use warnings;

our $VERSION = '2.006000';

use Moo::Role;

use GeoIP2::Types qw(
    Bool
    BoolCoercion
    NonNegativeInt
    PositiveInt
    Str
);
use Sub::Quote qw( quote_sub );

use namespace::clean;

with 'GeoIP2::Role::Record::HasNames';

has is_in_european_union => (
    is      => 'ro',
    isa     => Bool,
    default => quote_sub(q{ 0 }),
    coerce  => BoolCoercion,
);

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
