package GeoIP2::Role::HasIPAddress;

use strict;
use warnings;

our $VERSION = '2.003003';

use Moo::Role;
use namespace::autoclean;

use GeoIP2::Types qw( IPAddress );

has ip_address => (
    is       => 'ro',
    isa      => IPAddress,
    required => 1,
);

1;
