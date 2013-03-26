package GeoIP2::Record::Continent;

use strict;
use warnings;

use GeoIP2::Types qw( PositiveInt Str );

use Moo;

with 'GeoIP2::Role::HasNames';

has continent_code => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_continent_code',
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

  use v5.10;

  use GeoIP2::Webservice::Client;

  my $client = GeoIP2::Webservice::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  my $city = $client->city_isp_org( ip => '24.24.24.24' );

  my $continent_rec = $city->continent();
  say $continent_rec->name();

=head1 DESCRIPTION

This class contains the continent-level data associated with an IP address.

This record is returned by all the end points.

=head1 METHODS

This class provides the following methods:

=head2 $continent_rec->continent_code()

This returns a two character continent code like "NA" (North America) or "OC"
(Oceania).

This attribute is returned by all end points.

=head2 $continent_rec->geoname_id()

This returns a GeoName ID for the continent.

This attribute is returned by all end points.

=head2 $continent_rec->name()

This returns a name for the continent. The language chosen depends on the
C<languages> argument that was passed to the record's constructor. This will
be passed through from the L<GeoIP2::Webservice::Client> object you used to
fetch the data that populated this record.

If the record does not have a name in any of languages you asked for, this
method returns C<undef>.

This attribute is returned by all end points.

=head2 $continent_rec->names()

This returns a hash reference where the keys are language codes and the values
are names. See L<GeoIP2::Webservice::Client> for a list of the possible
language codes.

This attribute is returned by all end points.
