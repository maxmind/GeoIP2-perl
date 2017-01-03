package GeoIP2::Role::Error::HTTP;

use strict;
use warnings;

our $VERSION = '2.003003';

use Moo::Role;
use namespace::autoclean;

use GeoIP2::Types qw( HTTPStatus Str URIObject );

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
