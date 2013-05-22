package GeoIP2::Model::Country;

use strict;
use warnings;

use GeoIP2::Types qw( HashRef object_isa_type );
use Sub::Quote qw( quote_sub );

use Moo;

with 'GeoIP2::Role::Model';

__PACKAGE__->_define_attributes_for_keys(
    qw( continent country maxmind registered_country traits ));

1;

# ABSTRACT: Model class for the GeoIP2 Country end point

__END__

=head1 SYNOPSIS

  use 5.008;

  use GeoIP2::WebService::Client;

  my $client = GeoIP2::WebService::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  my $country = $client->country( ip => '24.24.24.24' );

  my $country_rec = $country->country();
  say $country_rec->iso_code();

=head1 DESCRIPTION

This class provides a model for the data returned by the GeoIP2 Country end
point.

=head1 METHODS

This class provides the following methods, each of which returns a record
object.

=head2 $country->continent()

Returns a L<GeoIP2::Record::Continent> object representing continent data for
the requested IP address.

=head2 $country->country()

Returns a L<GeoIP2::Record::Country> object representing country data for the
requested IP address. This record represents the country where MaxMind
believes the IP is located in.

=head2 $country->registered_country()

Returns a L<GeoIP2::Record::Country> object representing the registered
country data for the requested IP address. This record represents the country
where the ISP has registered a given IP block in and may differ from the
user's country.

=head2 $omni->represented_country()

Returns a L<GeoIP2::Record::RepresentedCountry> object for the country
represented by the requested IP address. The represented country may differ
from the C<country> for things like military bases or embassies.

=head2 $country->traits()

Returns a L<GeoIP2::Record::Traits> object representing the traits for the
request IP address.
