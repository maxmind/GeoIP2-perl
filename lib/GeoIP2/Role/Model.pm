package GeoIP2::Role::Model;

use strict;
use warnings;

use GeoIP2::Record::Country;
use GeoIP2::Record::Traits;
use GeoIP2::Types qw( HashRef );
use Sub::Quote qw( quote_sub );

use Moo::Role;

has raw => (
    is       => 'ro',
    isa      => HashRef,
    required => 1,
);

sub _define_attribute_for_key {
    my $class = shift;
    my $key   = shift;

    my $record_class = __PACKAGE__->_record_class_for_key($key);

    my $has = $class->can('has');

    $has->(
        $key => (
            is  => 'ro',
            isa => quote_sub(
                qq{ GeoIP2::Types::object_isa_type( \$_[0], '$record_class' ); }
            ),
            init_arg => undef,
            lazy     => 1,
            default  => quote_sub(qq{ \$_[0]->_build_record('$key') }),
        )
    );
}

sub _build_record {
    my $self = shift;
    my $key  = shift;

    return $self->_record_class_for_key($key)->new( $self->raw()->{$key} );
}

sub _record_class_for_key {
    my $self = shift;
    my $key  = shift;

    return 'GeoIP2::Record::' . ucfirst $key;
}

1;
