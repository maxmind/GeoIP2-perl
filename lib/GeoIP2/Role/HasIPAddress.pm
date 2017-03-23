package GeoIP2::Role::HasIPAddress;

use strict;
use warnings;

our $VERSION = '2.003005';

use Moo::Role;

use GeoIP2::Types qw( IPAddress );

use namespace::clean;

has ip_address => (
    is       => 'ro',
    isa      => IPAddress,
    required => 1,
);

1;
