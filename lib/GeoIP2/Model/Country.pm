package GeoIP2::Model::Country;

use strict;
use warnings;

use GeoIP2::Record::Country;
use GeoIP2::Types qw( HashRef object_isa_type );
use Sub::Quote qw( quote_sub );

use Moo;

with 'GeoIP2::Role::Model';

for my $key (qw( country traits )) {
    __PACKAGE__->_define_attribute_for_key($key);
}

1;
