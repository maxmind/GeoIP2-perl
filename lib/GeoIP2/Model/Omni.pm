package GeoIP2::Model::Omni;

use strict;
use warnings;

use GeoIP2::Types qw( HashRef object_isa_type );
use Sub::Quote qw( quote_sub );

use Moo;

with 'GeoIP2::Role::Model';

__PACKAGE__->_define_attributes_for_keys(
    qw( city continent country location region registered_country traits ));

1;
