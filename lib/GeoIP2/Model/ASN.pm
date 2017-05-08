package GeoIP2::Model::ASN;

use strict;
use warnings;

our $VERSION = '2.003006';

use Moo;

use GeoIP2::Types qw( IPAddress NonNegativeInt Str );

use namespace::clean -except => 'meta';

with 'GeoIP2::Role::Model::Flat', 'GeoIP2::Role::HasIPAddress';

has autonomous_system_number => (
    is        => 'ro',
    isa       => NonNegativeInt,
    predicate => 'has_autonomous_system_number',
);

has autonomous_system_organization => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_autonomous_system_organization',
);

1;

# ABSTRACT: Model class for the GeoLite2 ASN database

__END__

=head1 SYNOPSIS

  use 5.008;

  use GeoIP2::Model::ASN ();

  my $asn = GeoIP2::Model::ASN->new(
      raw => {
          autonomous_system_number => '217',
          autonomous_system_organization => 'University of Minnesota',
          ip_address => '128.101.101.101',
      }
  );

  print $asn->autonomous_system_number(), "\n";
  print $asn->autonomous_system_organization(), "\n";

=head1 DESCRIPTION

This class provides a model for the data returned by the GeoLite2 ASN database.

=head1 METHODS

This class provides the following methods:

=head2 $asn->autonomous_system_number()

This returns the autonomous system number
(L<http://en.wikipedia.org/wiki/Autonomous_system_(Internet)>) associated with
the IP address.

=head2 $asn->autonomous_system_organization()

This returns the organization associated with the registered autonomous system
number (L<http://en.wikipedia.org/wiki/Autonomous_system_(Internet)>) for the IP
address.

=head2 $asn->ip_address()

Returns the IP address used in the lookup.

=cut
