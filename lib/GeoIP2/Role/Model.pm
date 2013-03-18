package GeoIP2::Role::Model;

use strict;
use warnings;

use GeoIP2::Record::City;
use GeoIP2::Record::Continent;
use GeoIP2::Record::Country;
use GeoIP2::Record::Location;
use GeoIP2::Record::Region;
use GeoIP2::Record::Traits;
use GeoIP2::Types qw( HashRef );
use Sub::Quote qw( quote_sub );

use Moo::Role;

with 'GeoIP2::Role::HasLanguages';

sub _define_attributes_for_keys {
    my $class = shift;
    my @keys  = @_;

    my $has = $class->can('has');

    for my $key (@keys) {
        my $record_class = __PACKAGE__->_record_class_for_key($key);

        my $raw_attr = '_raw_' . $key;

        $has->(
            $raw_attr => (
                is       => 'ro',
                isa      => HashRef,
                init_arg => $key,
                default  => quote_sub(q{ {} }),
            ),
        );

        $has->(
            $key => (
                is  => 'ro',
                isa => quote_sub(
                    sprintf(
                        q{ GeoIP2::Types::object_isa_type( $_[0], %s ) },
                        B::perlstring($record_class)
                    )
                ),
                init_arg => undef,
                lazy     => 1,
                default  => quote_sub(
                    sprintf(
                        q{ $_[0]->_build_record( %s, %s ) },
                        map { B::perlstring($_) } $key, $raw_attr
                    )
                )
            )
        );
    }

    my $raw_default = join ', ',
        map { sprintf( '%s => $_[0]->_raw_%s', $_, $_ ) } @keys;

    $has->(
        raw => (
            is       => 'ro',
            isa      => HashRef,
            init_arg => 'raw',
            lazy     => 1,
            default  => quote_sub( sprintf(qq{return { $raw_default } }) )
        )
    );
}

sub _build_record {
    my $self   = shift;
    my $key    = shift;
    my $method = shift;

    my $raw = $self->$method();

    return $self->_record_class_for_key($key)
        ->new( %{$raw}, languages => $self->languages() );
}

sub _record_class_for_key {
    my $self = shift;
    my $key  = shift;

    return 'GeoIP2::Record::' . ucfirst $key;
}

1;
