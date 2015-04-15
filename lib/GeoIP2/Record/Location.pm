package GeoIP2::Record::Location;

use strict;
use warnings;

our $VERSION = '2.001004';

use GeoIP2::Types qw( NonNegativeInt Num PositiveInt Str );

use Moo;

has accuracy_radius => (
    is        => 'ro',
    isa       => PositiveInt,
    predicate => 'has_accuracy_radius',
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

This returns the radius in kilometers around the specified location where the
IP address is likely to be.

This attribute is only available from the Insights end point.

=head2 $location_rec->latitude()

This returns the latitude of the location as a floating point number.

This attribute is returned by all end points except the Country end point.

=head2 $location_rec->longitude()

This returns the longitude of the location as a floating point number.

This attribute is returned by all end points except the Country end point.

=head2 $location_rec->metro-code()

This returns the metro code of the location if the location is in the US.
MaxMind returns the same metro codes as the Google AdWords API
(L<https://developers.google.com/adwords/api/docs/appendix/cities-DMAregions>).

This attribute is returned by all end points except the Country end point.

=head2 $location_rec->time_zone()

This returns the time zone associated with a location, as specified by the IANA
Time Zone Database (L<http://www.iana.org/time-zones>), e.g., "America/New_York".

This attribute is returned by all end points except the Country end point.
