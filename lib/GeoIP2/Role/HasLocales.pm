package GeoIP2::Role::HasLocales;

use strict;
use warnings;

our $VERSION = '2.005001';

use Moo::Role;

use GeoIP2::Types qw( LocalesArrayRef );
use Sub::Quote qw( quote_sub );

use namespace::clean;

has locales => (
    is      => 'ro',
    isa     => LocalesArrayRef,
    default => quote_sub(q{ ['en'] }),
);

1;
