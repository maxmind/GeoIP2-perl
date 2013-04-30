package GeoIP2::Record::City;

use strict;
use warnings;

use GeoIP2::Types qw( NonNegativeInt PositiveInt Str );

use Moo;

with 'GeoIP2::Role::Record::HasNames';

has confidence => (
    is        => 'ro',
    isa       => NonNegativeInt,
    predicate => 'has_confidence',
);

has geoname_id => (
    is        => 'ro',
    isa       => PositiveInt,
    predicate => 'has_geoname_id',
);

1;

# ABSTRACT: Contains data for the city record associated with an IP address

__END__

=head1 SYNOPSIS

  use 5.008;

  use GeoIP2::Webservice::Client;

  my $client = GeoIP2::Webservice::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  my $city = $client->city_isp_org( ip => '24.24.24.24' );

  my $city_rec = $city->city();
  say $city_rec->name();

=head1 DESCRIPTION

This class contains the city-level data associated with an IP address.

This record is returned by all the end points except the Country end point.

=head1 METHODS

This class provides the following methods:

=head2 $city_rec->confidence()

This returns a value from 0-100 indicating MaxMind's confidence that the city
is correct.

This attribute is only available from the Omni end point.

=head2 $city_rec->geoname_id()

This returns a C<geoname_id> for the city.

This attribute is returned by all end points.

=head2 $city_rec->name()

This returns a name for the city. The language chosen depends on the
C<languages> argument that was passed to the record's constructor. This will
be passed through from the L<GeoIP2::Webservice::Client> object you used to
fetch the data that populated this record.

If the record does not have a name in any of languages you asked for, this
method returns C<undef>.

This attribute is returned by all end points.

=head2 $city_rec->names()

This returns a hash reference where the keys are language codes and the values
are names. See L<GeoIP2::Webservice::Client> for a list of the possible
language codes.

This attribute is returned by all end points.
