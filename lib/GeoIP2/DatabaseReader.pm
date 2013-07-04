package GeoIP2::DatabaseReader;

use strict;
use warnings;

use Moo;
with 'GeoIP2::Role::HasLanguages';

use GeoIP2::Model::Omni;
use MaxMind::DB::Reader;

has file => (
    is       => 'ro',
    required => 1,
);

has _reader => ( is => 'lazy', );

sub _build__reader {
    my $self = shift;
    return MaxMind::DB::Reader->new( file => $self->file );
}

sub _record_for_address {
    my $self = shift;
    return $self->_reader->record_for_address( shift );
}

sub omni {
    my $self   = shift;
    my $record = $self->_record_for_address( shift );
    use Data::Printer;
#    p $record;

    return GeoIP2::Model::Omni->new( %{$record},
        languages => $self->languages, );
}

1;
