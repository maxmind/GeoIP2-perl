package GeoIP2::Role::Model;

use strict;
use warnings;

our $VERSION = '2.006003';

use Moo::Role;

use GeoIP2::Types qw( HashRef );

use namespace::clean;

has raw => (
    is       => 'ro',
    isa      => HashRef,
    init_arg => 'raw',
    required => 1,
);

1;
