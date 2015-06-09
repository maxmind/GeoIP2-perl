package GeoIP2::Role::Model;

use strict;
use warnings;

our $VERSION = '2.002000';

use GeoIP2::Types qw( HashRef );

use Moo::Role;

has raw => (
    is       => 'ro',
    isa      => HashRef,
    init_arg => 'raw',
    required => 1,
);

1;
