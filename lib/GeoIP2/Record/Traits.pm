package GeoIP2::Record::Traits;

use strict;
use warnings;

use GeoIP2::Types qw( Bool BoolCoercion IPAddress NonNegativeInt Str );
use Sub::Quote qw( quote_sub );

use Moo;

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

has domain => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_domain',
);

has is_anonymous_proxy => (
    is      => 'ro',
    isa     => Bool,
    default => quote_sub(q{ 0 }),
    coerce  => BoolCoercion,
);

has is_satellite_provider => (
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
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  my $omni = $client->omni( ip => '24.24.24.24' );

  my $traits_rec = $omni->country();
  say $traits_rec->name();

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
endpoints.

=head2 $traits_rec->autonomous_system_organization()

This returns the organization associated with the registered autonomous system
number (L<http://en.wikipedia.org/wiki/Autonomous_system_(Internet)>) for the IP
address.

This attribute is only available from the City and Insights web service
endpoints.

=head2 $traits_rec->domain()

This returns the second level domain associated with the IP address. This will
be something like "example.com" or "example.co.uk", not "foo.example.com".

This attribute is only available from the City and Insights web service
endpoints.

=head2 $traits_rec->ip_address()

This returns the IP address that the data in the model is for. If you
performed a "me" lookup against the web service, this will be the externally
routable IP address for the system the code is running on. If the system is
behind a NAT, this may differ from the IP address locally assigned to it.

This attribute is returned by all end points.

=head2 $traits_rec->is_anonymous_proxy()

This returns true if the IP is an anonymous proxy. See
L<http://dev.maxmind.com/faq/geoip#anonproxy> for further details.

This attribute is returned by all end points.

=head2 $traits_rec->is_satellite_provider()

This returns true if the IP is a from a satellite provider that provides
service to multiple countries.

This attribute is returned by all end points.

=head2 $traits_rec->isp()

This returns the name of the ISP associated with the IP address.

This attribute is only available from the City and Insights web service
endpoints.

=head2 $traits_rec->organization()

This returns the name of the organization associated with the IP address.

This attribute is only available from the City and Insights web service
endpoints.

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

This attribute is only available from the Insights end point.
