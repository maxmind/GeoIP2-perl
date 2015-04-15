package GeoIP2::Role::Error::HTTP;

use strict;
use warnings;

our $VERSION = '2.001004';

use GeoIP2::Types qw( HTTPStatus Str URIObject );

use Moo::Role;

has http_status => (
    is       => 'ro',
    isa      => HTTPStatus,
    required => 1,
);

has uri => (
    is       => 'ro',
    isa      => URIObject,
    required => 1,
);

1;
