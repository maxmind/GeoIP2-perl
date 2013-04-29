package GeoIP2::Role::Model;

use strict;
use warnings;

use GeoIP2::Record::Subdivision;
use GeoIP2::Types qw( ArrayRef object_isa_type );
use Sub::Quote qw( quote_sub );

use Moo::Role;

with 'GeoIP2::Role::HasLanguages';

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
                languages => $self->languages(),
            );
        } @{ $self->_raw_subdivisions() }
    ];
}

sub _build_most_specific_subdivision {
    my $self = shift;

    my @subdivisions = $self->subdivisions();
    return $subdivisions[-1] if @subdivisions;

    return GeoIP2::Record::Subdivision->new(
        languages => $self->languages(),
    );
}

around _build_raw => sub {
    my $orig = shift;
    my $self = shift;

    my $raw = $self->$orig(@_);

    $raw->{subdivisions} = $self->_raw_subdivisions();

    return $raw;
};

1;
