package GeoIP2::Role::Model::HasSubdivisions;

use strict;
use warnings;

our $VERSION = '2.006002';

use Moo::Role;

use GeoIP2::Record::Subdivision;
use GeoIP2::Types qw( ArrayRef object_isa_type );
use Sub::Quote qw( quote_sub );

use namespace::clean;

with 'GeoIP2::Role::HasLocales';

has _raw_subdivisions => (
    is       => 'ro',
    isa      => ArrayRef,
    init_arg => 'subdivisions',
    lazy     => 1,
    default  => quote_sub(q{ [] }),
);

has _subdivisions => (
    is       => 'ro',
    isa      => ArrayRef,
    init_arg => undef,
    lazy     => 1,
    builder  => '_build_subdivisions',
);

has most_specific_subdivision => (
    is  => 'ro',
    isa => quote_sub(
        q{ GeoIP2::Types::object_isa_type( $_[0], 'GeoIP2::Record::Subdivision' ) },
    ),
    init_arg => undef,
    lazy     => 1,
    builder  => '_build_most_specific_subdivision',
);

sub subdivisions {
    return @{ $_[0]->_subdivisions() };
}

sub _build_subdivisions {
    my $self = shift;

    return [
        map {
            GeoIP2::Record::Subdivision->new(
                %{$_},
                locales => $self->locales(),
            );
        } @{ $self->_raw_subdivisions() }
    ];
}

sub _build_most_specific_subdivision {
    my $self = shift;

    my @subdivisions = $self->subdivisions();
    return $subdivisions[-1] if @subdivisions;

    return GeoIP2::Record::Subdivision->new(
        locales => $self->locales(),
    );
}

1;
