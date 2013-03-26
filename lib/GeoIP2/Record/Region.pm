package GeoIP2::Record::Region;

use strict;
use warnings;

use GeoIP2::Types qw( NonNegativeInt PositiveInt Str );

use Moo;

with 'GeoIP2::Role::HasNames';

has confidence => (
    is        => 'ro',
    isa       => NonNegativeInt,
    predicate => 'has_confidence',
);

has geoname_id => (
    is       => 'ro',
    isa      => PositiveInt,
    predicate => 'has_geoname_id',
);

has iso_3166_2 => (
    is       => 'ro',
    isa      => Str,
    predicate => 'has_iso_3166_2',
);

1;

# ABSTRACT: Contains data for the region record associated with an IP address

__END__

=head1 SYNOPSIS

  use v5.10;

  use GeoIP2::Webservice::Client;

  my $client = GeoIP2::Webservice::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  my $city = $client->city_isp_org( ip => '24.24.24.24' );

  my $region_rec = $city->region();
  say $region_rec->name();

=head1 DESCRIPTION

This class contains the region-level data associated with an IP address. A
region is a sub-country level administrative boundary, such as a province or
state.

This record is returned by all the end points except the Country end point.

=head1 METHODS

This class provides the following methods:

=head2 $region_rec->confidence()

This returns a value from 0-100 indicating MaxMind's confidence that the
region is correct.

This attribute is only available from the Omni end point.

=head2 $region_rec->geoname_id()

This returns a GeoName ID for the region.

This attribute is returned by all end points except the Country end point.

=head2 $region_rec->iso_3166_2()

This returns a string up to three characters long contain the region portion
of the ISO 3166-2 code (http://en.wikipedia.org/wiki/ISO_3166-2).

This attribute is returned by all end points except the Country end point.

=head2 $region_rec->name()

This returns a name for the region. The language chosen depends on the
C<languages> argument that was passed to the record's constructor. This will
be passed through from the L<GeoIP2::Webservice::Client> object you used to
fetch the data that populated this record.

If the record does not have a name in any of languages you asked for, this
method returns C<undef>.

This attribute is returned by all end points except the Country end point.

=head2 $region_rec->names()

This returns a hash reference where the keys are language codes and the values
are names. See L<GeoIP2::Webservice::Client> for a list of the possible
language codes.

This attribute is returned by all end points except the Country end point.
