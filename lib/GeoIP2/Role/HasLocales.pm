package GeoIP2::Role::HasLocales;

use strict;
use warnings;

our $VERSION = '2.003003';

use Moo::Role;
use namespace::autoclean;

use GeoIP2::Types qw( LocalesArrayRef );
use Sub::Quote qw( quote_sub );

has locales => (
    is      => 'ro',
    isa     => LocalesArrayRef,
    default => quote_sub(q{ ['en'] }),
);

1;
