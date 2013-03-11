package GeoIP2::Record::Traits;

use strict;
use warnings;

use GeoIP2::Types qw( Bool IPAddress NonNegativeInt Str );
use Sub::Quote qw( quote_sub );

use Moo;

has ip_address => (
    is       => 'ro',
    isa      => IPAddress,
    required => 1,
);

has autonomous_system_number => (
    is        => 'ro',
    isa       => NonNegativeInt,
    predicate => 'has_autonomous_system_number',
);

has domain => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_domain',
);

has is_anonymous_proxy => (
    is      => 'ro',
    isa     => Bool,
    default => quote_sub(q{ 0 })
);

has is_transparent_proxy => (
    is      => 'ro',
    isa     => Bool,
    default => quote_sub(q{ 0 })
);

has is_us_military => (
    is      => 'ro',
    isa     => Bool,
    default => quote_sub(q{ 0 })
);

has isp => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_isp',
);

has network_speed => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_network_speed',
);

has organization => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_organization',
);

1;
