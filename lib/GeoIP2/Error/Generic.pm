package GeoIP2::Error::Generic;

use strict;
use warnings;

use GeoIP2::Types qw( Str );

use Moo;

with 'Throwable';

has error => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

1;
