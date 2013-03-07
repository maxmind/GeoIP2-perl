package GeoIP2::Role::Error::HTTP;

use strict;
use warnings;

use GeoIP2::Types qw( HTTPStatus URIObject );

use Moo::Role;

has error => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has http_status => (
    is       => 'ro',
    isa      => HTTPStatus,
    required => 1,
);

has URI => (
    is       => 'ro',
    isa      => URIObject,
    required => 1,
);

1;
