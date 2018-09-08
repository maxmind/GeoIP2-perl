package GeoIP2::Record::Traits;

use strict;
use warnings;

our $VERSION = '2.006002';

use Moo;

use GeoIP2::Types qw( Bool BoolCoercion IPAddress NonNegativeInt Str );
use Sub::Quote qw( quote_sub );

use namespace::clean -except => 'meta';

with 'GeoIP2::Role::HasIPAddress';

has autonomous_system_number => (
    is        => 'ro',
    isa       => NonNegativeInt,
    predicate => 'has_autonomous_system_number',
);

has autonomous_system_organization => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_autonomous_system_organization',
);

has connection_type => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_connection_type',
);

has domain => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_domain',
);

has [
    'is_anonymous',
    'is_anonymous_proxy',
    'is_anonymous_vpn',
    'is_hosting_provider',
    'is_legitimate_proxy',
    'is_public_proxy',
    'is_satellite_provider',
    'is_tor_exit_node',
] => (
    is      => 'ro',
    isa     => Bool,
    default => quote_sub(q{ 0 }),
    coerce  => BoolCoercion,
);

has isp => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_isp',
);

has organization => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_organization',
);

has user_type => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_user_type',
);

1;

# ABSTRACT: Contains data for the traits record associated with an IP address

__END__

=head1 SYNOPSIS

  use 5.008;

  use GeoIP2::WebService::Client;

  my $client = GeoIP2::WebService::Client->new(
      account_id  => 42,
      license_key => 'abcdef123456',
  );

  my $insights = $client->insights( ip => '24.24.24.24' );

  my $traits_rec = $insights->country();
  print $traits_rec->name(), "\n";

=head1 DESCRIPTION

This class contains the traits data associated with an IP address.

This record is returned by all the end points.

=head1 METHODS

This class provides the following methods:

=head2 $traits_rec->autonomous_system_number()

This returns the autonomous system number
(L<http://en.wikipedia.org/wiki/Autonomous_system_(Internet)>) associated with
the IP address.

This attribute is only available from the City and Insights web service
endpoints and the GeoIP2 Enterprise database.

=head2 $traits_rec->autonomous_system_organization()

This returns the organization associated with the registered autonomous system
number (L<http://en.wikipedia.org/wiki/Autonomous_system_(Internet)>) for the IP
address.

This attribute is only available from the City and Insights web service
endpoints and the GeoIP2 Enterprise database.

=head2 $traits_rec->connection_type()

This returns the connection type associated with the IP address. It may take
the following values: C<Dialup>, C<Cable/DSL>, C<Corporate>, or C<Cellular>.
Additional values may be added in the future.

This attribute is only available in the GeoIP2 Enterprise database.

=head2 $traits_rec->domain()

This returns the second level domain associated with the IP address. This will
be something like "example.com" or "example.co.uk", not "foo.example.com".

This attribute is only available from the City and Insights web service
endpoints and the GeoIP2 Enterprise database.

=head2 $traits_rec->ip_address()

This returns the IP address that the data in the model is for. If you
performed a "me" lookup against the web service, this will be the externally
routable IP address for the system the code is running on. If the system is
behind a NAT, this may differ from the IP address locally assigned to it.

This attribute is returned by all end points.

=head2 $traits_rec->is_anonymous()

This returns a true value if the IP address belongs to any sort of anonymous
network and a false value otherwise.

This attribute is only available from the Insights web service.

=head2 $traits_rec->is_anonymous_proxy()

I<Deprecated.> Please see our L<GeoIP2 Anonymous IP
database|https://www.maxmind.com/en/geoip2-anonymous-ip-database> or our
L<GeoIP2 Precision Insights service|https://www.maxmind.com/en/geoip2-precision-insights>
to determine whether the IP address is used by an anonymizing service.

This attribute is returned by all end points.

=head2 $traits_rec->is_anonymous_vpn()

This returns a true value if the IP address belongs to an anonymous VPN
system and a false value otherwise.

This attribute is only available from the Insights web service.

=head2 $traits_rec->is_hosting_provider()

This returns a true value if the IP address belongs to a hosting provider and
a false value otherwise.

This attribute is only available from the Insights web service.

=head2 $traits_rec->is_legitimate_proxy()

This attribute returns true if MaxMind believes this IP address to be a
legitimate proxy, such as an internal VPN used by a corporation

This attribute is only available in the GeoIP2 Enterprise database.

=head2 $traits_rec->is_public_proxy()

This returns a true value if the IP address belongs to a public proxy and
a false value otherwise.

This attribute is only available from the Insights web service.

=head2 $traits_rec->is_satellite_provider()

I<Deprecated.> Due to the increased coverage by mobile carriers, very few
satellite providers now serve multiple countries. As a result, the
output does not provide sufficiently relevant data for us to maintain it.

This attribute is returned by all end points.

=head2 $traits_rec->is_tor_exit_node()

This returns a true value if the IP address is a Tor exit node and a false
value otherwise.

This attribute is only available from the Insights web service.

=head2 $traits_rec->isp()

This returns the name of the ISP associated with the IP address.

This attribute is only available from the City and Insights web service
endpoints and the GeoIP2 Enterprise database.

=head2 $traits_rec->organization()

This returns the name of the organization associated with the IP address.

This attribute is only available from the City and Insights web service
endpoints and the GeoIP2 Enterprise database.

=head2 $traits_rec->user_type()

This returns the user type associated with the IP address. This can be one of
the following values:

=over 4

=item * business

=item * cafe

=item * cellular

=item * college

=item * content_delivery_network

=item * dialup

=item * government

=item * hosting

=item * library

=item * military

=item * residential

=item * router

=item * school

=item * search_engine_spider

=item * traveler

=back

This attribute is only available from the Insights end point and the GeoIP2
Enterprise database.
