package GeoIP2::Record::Country;

use strict;
use warnings;

our $VERSION = '2.006002';

use Moo;

use namespace::clean -except => 'meta';

with 'GeoIP2::Role::Record::Country';

1;

# ABSTRACT: Contains data for the country record associated with an IP address

__END__

=head1 SYNOPSIS

  use 5.008;

  use GeoIP2::WebService::Client;

  my $client = GeoIP2::WebService::Client->new(
      account_id  => 42,
      license_key => 'abcdef123456',
  );

  my $insights = $client->insights( ip => '24.24.24.24' );

  my $country_rec = $insights->country();
  print $country_rec->name(), "\n";

=head1 DESCRIPTION

This class contains the country-level data associated with an IP address.

This record is returned by all the end points.

=head1 METHODS

This class provides the following methods:

=head2 $country_rec->confidence()

This returns a value from 0-100 indicating MaxMind's confidence that the
country is correct.

This attribute is only available from the Insights end point and the GeoIP2
Enterprise database.

=head2 $country_rec->geoname_id()

This returns a C<geoname_id> for the country.

This attribute is returned by all end points.

=head2 $country_rec->is_in_european_union()

This returns a true value if the country is a member state of the European
Union and a false value otherwise.

This attribute is available from all web service end points and the GeoIP2
Country, City, and Enterprise databases.

=head2 $country_rec->iso_code()

This returns the two-character ISO 3166-1
(L<http://en.wikipedia.org/wiki/ISO_3166-1>) alpha code for the country.

This attribute is returned by all end points.

=head2 $country_rec->name()

This returns a name for the country. The locale chosen depends on the
C<locales> argument that was passed to the record's constructor. This will be
passed through from the L<GeoIP2::WebService::Client> object you used to fetch
the data that populated this record.

If the record does not have a name in any of the locales you asked for, this
method returns C<undef>.

This attribute is returned by all end points.

=head2 $country_rec->names()

This returns a hash reference where the keys are locale codes and the values
are names. See L<GeoIP2::WebService::Client> for a list of the possible
locale codes.

This attribute is returned by all end points.
