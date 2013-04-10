package GeoIP2::Model::CityISPOrg;

use strict;
use warnings;

use GeoIP2::Types qw( HashRef object_isa_type );
use Sub::Quote qw( quote_sub );

use Moo;

with 'GeoIP2::Role::Model';

__PACKAGE__->_define_attributes_for_keys(
    qw( city continent country location region registered_country traits ));

1;

# ABSTRACT: Model class for the GeoIP2 Precision City/ISP/Org end point

__END__

=head1 SYNOPSIS

  use v5.10;

  use GeoIP2::Webservice::Client;

  my $client = GeoIP2::Webservice::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  my $city_isp_org = $client->city_isp_org( ip => '24.24.24.24' );

  my $city_rec = $city_isp_org->city();
  say $city_rec->name();

=head1 DESCRIPTION

This class provides a model for the data returned by the GeoIP2 Precision
City/ISP/Org end point.

The only difference between the City, City/ISP/Org, and Omni model classes is
which fields in each record may be populated. See
http://dev.maxmind.com/geoip/precision for more details.

=head1 METHODS

This class provides the following methods, each of which returns a record
object.

=head2 $city_isp_org->city()

Returns a L<GeoIP2::Record::City> object representing country data for the
requested IP address.

=head2 $city_isp_org->continent()

Returns a L<GeoIP2::Record::Continent> object representing continent data for
the requested IP address.

=head2 $city_isp_org->country()

Returns a L<GeoIP2::Record::Country> object representing country data for the
requested IP address. This record represents the country where MaxMind
believes the IP is located in.

=head2 $city_isp_org->location()

Returns a L<GeoIP2::Record::Location> object representing country data for the
requested IP address.

=head2 $city_isp_org->region()

Returns a L<GeoIP2::Record::Region> object representing country data for the
requested IP address.

=head2 $city_isp_org->registered_country()

Returns a L<GeoIP2::Record::Country> object representing the registered
country data for the requested IP address. This record represents the country
where the ISP has registered a given IP block in and may differ from the
user's country.

=head2 $city_isp_org->traits()

Returns a L<GeoIP2::Record::Traits> object representing the traits for the
request IP address.
