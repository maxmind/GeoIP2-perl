package GeoIP2::Database::Reader;

use strict;
use warnings;

use Carp qw( croak );
use GeoIP2::Error::Generic;
use GeoIP2::Error::IPAddressNotFound;
use GeoIP2::Model::City;
use GeoIP2::Model::CityISPOrg;
use GeoIP2::Model::ConnectionType;
use GeoIP2::Model::Country;
use GeoIP2::Model::Domain;
use GeoIP2::Model::ISP;
use GeoIP2::Model::Omni;
use GeoIP2::Model::Omni;
use GeoIP2::Types qw( Str );
use MaxMind::DB::Reader;

use Moo;

with 'GeoIP2::Role::HasLocales';

has file => (
    is       => 'ro',
    isa      => Str,
    required => 1,
    coerce   => sub { "$_[0]" },
);

has _reader => (
    is      => 'ro',
    does    => 'MaxMind::DB::Reader::Role::Reader',
    lazy    => 1,
    builder => '_build_reader',
);

sub _build_reader {
    my $self = shift;
    return MaxMind::DB::Reader->new( file => $self->file );
}

sub _model_for_address {
    my $self  = shift;
    my $class = shift;
    my %args  = @_;
    my $ip    = $args{ip};

    unless ( defined $ip ) {
        my ($method) = ( caller(1) )[3];
        GeoIP2::Error::Generic->throw( message =>
                "Required param (ip) was missing when calling $method on "
                . __PACKAGE__ );
    }

    if ( $ip eq 'me' ) {
        my ($method) = ( caller(1) )[3];
        GeoIP2::Error::Generic->throw(
                  message => "me is not a valid IP when calling $method on "
                . __PACKAGE__ );
    }

    my $record = $self->_reader->record_for_address($ip);
    unless ($record) {
        GeoIP2::Error::IPAddressNotFound->throw(
            message    => "No record found for IP address $ip",
            ip_address => $ip,
        );
    }

    my $model_class = 'GeoIP2::Model::' . $class;

    if ( $args{is_flat} ) {
        $record->{ip_address} = $ip;
    }
    else {
        $record->{traits} ||= {};
        $record->{traits}{ip_address} = $ip;
    }

    return $model_class->new( %{$record}, locales => $self->locales, );
}

sub city {
    my $self = shift;
    return $self->_model_for_address( 'City', @_ );
}

sub city_isp_org {
    my $self = shift;
    return $self->_model_for_address( 'CityISPOrg', @_ );
}

sub country {
    my $self = shift;
    return $self->_model_for_address( 'Country', @_ );
}

sub omni {
    my $self = shift;
    return $self->_model_for_address( 'Omni', @_ );
}

sub connection_type {
    my $self = shift;
    return $self->_model_for_address( 'ConnectionType', is_flat => 1, @_ );
}

sub domain {
    my $self = shift;
    return $self->_model_for_address( 'Domain', is_flat => 1, @_ );
}

sub isp {
    my $self = shift;
    return $self->_model_for_address( 'ISP', is_flat => 1, @_ );
}

1;

# ABSTRACT: Perl API for GeoIP2 databases

__END__

=pod

=head1 SYNOPSIS

  use 5.008;

  use GeoIP2::Database::Reader;

  my $reader = GeoIP2::Database::Reader->new(
      file    => '/path/to/database',
      locales => [ 'en', 'de', ]
  );

  my $omni = $reader->omni( ip => '24.24.24.24' );
  my $country = $omni->country();
  say $country->is_code();

=head1 DESCRIPTION

This class provides a reader API for all GeoIP2 databases. Each method returns
a different model class.

If the database does not return a particular piece of data for an IP address,
the associated attribute is not populated.

=head1 USAGE

The basic API for this class is the same for all database types.  First you
create a database reader object with your C<file> and C<locale> params.
Then you call the method corresponding to your database type, passing it the
IP address you want to look up.

If the request succeeds, the method call will return a model class for the
method point you called.

If the database cannot be read, the reader class throws an exception.

=head1 CONSTRUCTOR

This class has a single constructor method:

=head2 GeoIP2::Database::Reader->new()

This method creates a new object. It accepts the following arguments:

=over 4

=item * file

This is the path to the GeoIP2 database file which you'd like to query.

=item * locales

This is an array reference where each value is a string indicating a locale.
This argument will be passed on to record classes to use when their C<name()>
methods are called.

The order of the locales is significant. When a record class has multiple
names (country, city, etc.), its C<name()> method will look at each element of
this array ref and return the first locale for which it has a name.

Note that the only locale which is always present in the GeoIP2 data in "en".
If you do not include this locale, the C<name()> method may end up returning
C<undef> even when the record in question has an English name.

Currently, the valid list of locale codes is:

=over 8

=item * de - German

=item * en - English

English names may still include accented characters if that is the accepted
spelling in English. In other words, English does not mean ASCII.

=item * es - Spanish

=item * fr - French

=item * ja - Japanese

=item * pt-BR - Brazilian Portuguese

=item * ru - Russian

=item * zh-CN - simplified Chinese

=back

Passing any other locale code will result in an error.

The default value for this argument is C<['en']>.

=back

=head1 REQUEST METHODS

All of the request methods accept a single argument:

=over 4

=item * ip

This must be a valid IPv4 or IPv6 address. This is the address that you want to
look up using the GeoIP2 web service.

Unlike the web service client class, you cannot pass the string "me" as your ip
address.

=back

=head2 $reader->coonnection_type()

This method returns a L<GeoIP2::Model::ConnectionType> object.

=head2 $reader->country()

This method returns a L<GeoIP2::Model::Country> object.

=head2 $reader->city()

This method returns a L<GeoIP2::Model::City> object.

=head2 $reader->city_isp_org()

This method returns a L<GeoIP2::Model::CityISPOrg> object.

=head2 $reader->domain()

This method returns a L<GeoIP2::Model::Domain> object.

=head2 $reader->isp()

This method returns a L<GeoIP2::Model::ISP> object.

=head2 $reader->omni()

This method returns a L<GeoIP2::Model::Omni> object.

Note that the data which makes the Omni web service different from
City/ISP/Org is not available in any downloadable database. This means that
calling the C<< $reader->omni() >> always returns the same data as as C<<
$reader->city_isp_org() >>.

=head1 EXCEPTIONS

In the case of a fatal error, the reader will throw a L<GeoIP2::Error::Generic>
object.

This error class has an C<< $error->message() >> method and overload
stringification to show that message. This means that if you don't explicitly
catch errors they will ultimately be sent to C<STDERR> with some sort of
(hopefully) useful error message.

=head1 WHAT DATA IS RETURNED?

While many of the databases return the same basic records, the attributes which
can be populated vary between model classes. In addition, while a database may
offer a particular piece of data, MaxMind does not always have every piece of
data for any given IP address.

Because of these factors, it is possible for any model class to return a record
where some or all of the attributes are unpopulated.

See L<http://dev.maxmind.com/geoip/geoip2/web-services> for details on what
data each end point I<may> return.

Every record class attribute has a corresponding predicate method so you can
check to see if the attribute is set.

=cut
