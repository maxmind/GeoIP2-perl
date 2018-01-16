package GeoIP2::Model::Enterprise;

use strict;
use warnings;

our $VERSION = '2.005000';

use Moo;

use namespace::clean -except => 'meta';

with 'GeoIP2::Role::Model::Location', 'GeoIP2::Role::Model::HasSubdivisions';

## no critic (ProhibitUnusedPrivateSubroutines)
sub _has { has(@_) }
## use critic

__PACKAGE__->_define_attributes_for_keys( __PACKAGE__->_all_record_names() );

1;

# ABSTRACT: Model class for GeoIP2 Enterprise

__END__

=head1 SYNOPSIS

  use 5.008;

  use GeoIP2::WebService::Client;

  my $reader = GeoIP2::Database::Reader->new(
      file    => '/path/to/database',
      locales => [ 'en', 'de', ]
  );

  my $enterprise = $reader->enterprise( ip => '24.24.24.24' );

  my $city_rec = $enterprise->city();
  print $city_rec->name(), "\n";

=head1 DESCRIPTION

This class provides a model for the data returned by the GeoIP2 Enterprise
database.

The only difference between the City and Enterprise model classes is
which fields in each record may be populated. See
L<http://dev.maxmind.com/geoip/geoip2/web-services> for more details.

=head1 METHODS

This class provides the following methods.

=head2 $enterprise->city()

Returns a L<GeoIP2::Record::City> object representing city data for the
requested IP address.

=head2 $enterprise->continent()

Returns a L<GeoIP2::Record::Continent> object representing continent data for
the requested IP address.

=head2 $enterprise->country()

Returns a L<GeoIP2::Record::Country> object representing country data for the
requested IP address. This record represents the country where MaxMind
believes the IP is located.

=head2 $enterprise->location()

Returns a L<GeoIP2::Record::Location> object representing location data for the
requested IP address.

=head2 $enterprise->postal()

Returns a L<GeoIP2::Record::Postal> object representing postal code data for
the requested IP address.

=head2 $enterprise->registered_country()

Returns a L<GeoIP2::Record::Country> object representing the registered
country data for the requested IP address. This record represents the country
where the ISP has registered a given IP block and may differ from the
user's country.

=head2 $enterprise->represented_country()

Returns a L<GeoIP2::Record::RepresentedCountry> object for the country
represented by the requested IP address. The represented country may differ
from the C<country> for things like military bases.

=head2 $enterprise->subdivisions()

Returns an array of L<GeoIP2::Record::Subdivision> objects representing the
country subdivisions for the requested IP address. The number and type of
subdivisions varies by country, but a subdivision is typically a state,
province, county, etc.

Some countries have multiple levels of subdivisions. For instance, the
subdivisions array for Oxford in the United Kingdom would have England as the
first element and Oxfordshire as the second element. The subdivisions array
for Minneapolis in the United States would have a single object for Minnesota.

If the response did not contain any subdivisions, this method returns an empty
list.

=head2 $enterprise->most_specific_subdivision()

Returns a single L<GeoIP2::Record::Subdivision> object representing the most
specific subdivision returned.

If the response did not contain any subdivisions, this method returns a
L<GeoIP2::Record::Subdivision> object with no values.

=head2 $enterprise->traits()

Returns a L<GeoIP2::Record::Traits> object representing the traits for the
requested IP address.
