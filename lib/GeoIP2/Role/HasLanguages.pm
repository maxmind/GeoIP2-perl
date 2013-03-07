package GeoIP2::Role::HasLanguages;

use strict;
use warnings;

use GeoIP2::Types qw( LanguagesArrayRef );
use Sub::Quote qw( quote_sub );

use Moo::Role;

has languages => (
    is      => 'ro',
    isa     => LanguagesArrayRef,
    default => quote_sub(q{ ['en'] }),
);

1;
