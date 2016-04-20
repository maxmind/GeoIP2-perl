package GeoIP2::Record::Continent;

use strict;
use warnings;

our $VERSION = '2.003000';

use GeoIP2::Types qw( PositiveInt Str );

use Moo;

with 'GeoIP2::Role::Record::HasNames';

has code => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_code',
);

has geoname_id => (
    is        => 'ro',
    isa       => PositiveInt,
    predicate => 'has_geoname_id',
);

1;

# ABSTRACT: Contains data for the continent record associated with an IP address

__END__

=head1 SYNOPSIS

  use 5.008;

  use GeoIP2::WebService::Client;

  my $client = GeoIP2::WebService::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  my $insights = $client->insights( ip => '24.24.24.24' );

  my $continent_rec = $insights->continent();
  print $continent_rec->name(), "\n";

=head1 DESCRIPTION

This class contains the continent-level data associated with an IP address.

This record is returned by all the end points.

=head1 METHODS

This class provides the following methods:

=head2 $continent_rec->code()

This returns a two character continent code like "NA" (North America) or "OC"
(Oceania).

This attribute is returned by all end points.

=head2 $continent_rec->geoname_id()

This returns a C<geoname_id> for the continent.

This attribute is returned by all end points.

=head2 $continent_rec->name()

This returns a name for the continent. The locale chosen depends on the
C<locales> argument that was passed to the record's constructor. This will be
passed through from the L<GeoIP2::WebService::Client> object you used to fetch
the data that populated this record.

If the record does not have a name in any of the locales you asked for, this
method returns C<undef>.

This attribute is returned by all end points.

=head2 $continent_rec->names()

This returns a hash reference where the keys are locale codes and the values
are names. See L<GeoIP2::WebService::Client> for a list of the possible
locale codes.

This attribute is returned by all end points.
