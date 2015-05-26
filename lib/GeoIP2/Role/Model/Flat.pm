package GeoIP2::Role::Model::Flat;

use strict;
use warnings;

our $VERSION = '2.001004';

use Moo::Role;

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    my %p = @_;

    return $self->$orig( %{ $p{raw} }, %p );
};

1;
