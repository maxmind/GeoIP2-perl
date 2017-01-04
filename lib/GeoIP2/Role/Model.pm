package GeoIP2::Role::Model;

use strict;
use warnings;

our $VERSION = '2.003003';

use Moo::Role;
use namespace::autoclean;

use GeoIP2::Types qw( HashRef );

has raw => (
    is       => 'ro',
    isa      => HashRef,
    init_arg => 'raw',
    required => 1,
);

1;
