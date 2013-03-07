package GeoIP2::Error::Webservice;

use strict;
use warnings;

use GeoIP2::Types qw( Str );

use Moo;

with 'GeoIP2::Role::Error::HTTP', 'Throwable';

has code => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

1;
