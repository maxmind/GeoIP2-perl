package GeoIP2::Error::HTTP;

use strict;
use warnings;

use GeoIP2::Types qw( Str );

use Moo;

with 'GeoIP2::Role::Error::HTTP';

extends 'Throwable::Error';

1;
