package GeoIP2::Role::HasNames;

use strict;
use warnings;

use GeoIP2::Types qw( MaybeStr NameHashRef );
use List::Util qw( first );

use Moo::Role;

with 'GeoIP2::Role::HasLanguages';

has name => (
    is      => 'ro',
    isa     => MaybeStr,
    lazy    => 1,
    builder => '_build_name',
);

has names => (
    is       => 'ro',
    isa      => NameHashRef,
    required => 1,
);

sub _build_name {
    my $self = shift;

    my $names = $self->names();

    my $lang = first { exists $names->{$_} } @{ $self->languages() };

    return unless $lang;
    return $names->{$lang};
}

1;
