package GeoIP2::Record::Location;

use strict;
use warnings;

our $VERSION = '2.003005';

use Moo;

use GeoIP2::Types qw( NonNegativeInt Num PositiveInt Str );

use namespace::clean -except => 'meta';

has accuracy_radius => (
    is        => 'ro',
    isa       => PositiveInt,
    predicate => 'has_accuracy_radius',
);

has average_income => (
    is        => 'ro',
    isa       => NonNegativeInt,
    predicate => 'has_average_income',
);

has latitude => (
    is        => 'ro',
    isa       => Num,
    predicate => 'has_latitude',
);

has longitude => (
    is        => 'ro',
    isa       => Num,
    predicate => 'has_longitude',
);

has metro_code => (
    is        => 'ro',
    isa       => PositiveInt,
    predicate => 'has_metro_code',
);

has population_density => (
    is        => 'ro',
    isa       => NonNegativeInt,
    predicate => 'has_population_density',
);

has time_zone => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_time_zone',
);

1;

# ABSTRACT: Contains data for the location record associated with an IP address

__END__

=head1 SYNOPSIS

  use 5.008;

  use GeoIP2::WebService::Client;

  my $client = GeoIP2::WebService::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  my $insights = $client->insights( ip => '24.24.24.24' );

  my $location_rec = $insights->location();
  print $location_rec->name(), "\n";

=head1 DESCRIPTION

This class contains the location data associated with an IP address.

This record is returned by all the end points except the Country end point.

=head1 METHODS

This class provides the following methods:

=head2 $location_rec->accuracy_radius()

The approximate accuracy radius in kilometers around the latitude and
longitude for the IP address. This is the radius where we have a 67%
confidence that the device using the IP address resides within the circle
centered at the latitude and longitude with the provided radius.

This attribute is returned by all end points and location databases except
Country.

=head2 $location_rec->average_income()

This returns a non-negative integer representing the average income in US
dollars associated with the requested IP address.

This attribute is only available from the Insights end point and the GeoIP2
Enterprise database.

=head2 $location_rec->latitude()

The approximate latitude of the location associated with the IP address. This
value is not precise and should not be used to identify a particular address
or household.

This attribute is returned by all end points and location databases except
Country.

=head2 $location_rec->longitude()

The approximate longitude of the location associated with the IP address. This
value is not precise and should not be used to identify a particular address
or household.

This attribute is returned by all end points and location databases except
Country.

=head2 $location_rec->metro-code()

This returns the metro code of the location if the location is in the US.
MaxMind returns the same metro codes as the Google AdWords API
(L<https://developers.google.com/adwords/api/docs/appendix/cities-DMAregions>).

This attribute is returned by all end points except the Country end point.

=head2 $location_rec->population_density()

Returns a non-negative integer representing the estimated population per square
kilometer associated with the requested IP address.

This attribute is only available from the Insights end point and the GeoIP2
Enterprise database.

=head2 $location_rec->time_zone()

This returns the time zone associated with a location, as specified by the IANA
Time Zone Database (L<http://www.iana.org/time-zones>), e.g., "America/New_York".

This attribute is returned by all end points except the Country end point.
