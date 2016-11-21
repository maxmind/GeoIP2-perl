package GeoIP2::Role::Record::HasNames;

use strict;
use warnings;

our $VERSION = '2.003003';

use GeoIP2::Types qw( MaybeStr NameHashRef );
use List::Util qw( first );
use Sub::Quote qw( quote_sub );

use Moo::Role;

with 'GeoIP2::Role::HasLocales';

has name => (
    is      => 'ro',
    isa     => MaybeStr,
    lazy    => 1,
    builder => '_build_name',
);

has names => (
    is      => 'ro',
    isa     => NameHashRef,
    default => quote_sub(q{ {} }),
);

sub _build_name {
    my $self = shift;

    my $names = $self->names();

    my $lang = first { exists $names->{$_} } @{ $self->locales() };

    return unless $lang;
    return $names->{$lang};
}

1;
