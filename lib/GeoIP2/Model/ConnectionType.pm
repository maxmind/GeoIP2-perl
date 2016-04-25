package GeoIP2::Model::ConnectionType;

use strict;
use warnings;

our $VERSION = '2.003002';

use GeoIP2::Types qw( IPAddress Str );

use Moo;

with 'GeoIP2::Role::Model::Flat', 'GeoIP2::Role::HasIPAddress';

has connection_type => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_connection_type',
);

1;

# ABSTRACT: Model class for the GeoIP2 Connection Type database

__END__

=head1 SYNOPSIS

  use 5.008;

  use GeoIP2::Model::ConnectionType;

  my $conn = GeoIP2::Model::ConnectionType->new(
      raw => { connection_type => 'Corporate', ip_address => '24.24.24.24'}
  );

  print $conn->connection_type(), "\n";

=head1 DESCRIPTION

This class provides a model for the data returned by the GeoIP2 Connection
Type database.

=head1 METHODS

This class provides the following methods:

=head2 $conn->connection_type()

Returns the connection type as a string.

=head2 $conn->ip_address()

Returns the IP address used in the lookup.
