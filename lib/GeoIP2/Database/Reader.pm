package GeoIP2::Database::Reader;

use strict;
use warnings;

use Moo;
with 'GeoIP2::Role::HasLanguages';

use Carp qw( croak );
use GeoIP2::Error::Generic;
use GeoIP2::Model::City;
use GeoIP2::Model::CityISPOrg;
use GeoIP2::Model::Country;
use GeoIP2::Model::Omni;
use GeoIP2::Model::Omni;
use MaxMind::DB::Reader;

has file => (
    is       => 'ro',
    required => 1,
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
        my ( $method ) = ( caller( 1 ) )[3];
        GeoIP2::Error::Generic->throw(
            message => "Required param (ip) was missing in call to $method" );
    }

    if ( $ip eq 'me' ) {
        my ( $method ) = ( caller( 1 ) )[3];
        GeoIP2::Error::Generic->throw(
            message => "me is not a valid lookup IP in call to $method" );
    }

    my $record      = $self->_reader->record_for_address( $ip );
    my $model_class = 'GeoIP2::Model::' . $class;

    return $model_class->new( %{$record}, languages => $self->languages, );
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

1;

# ABSTRACT: Perl API for GeoIP2 databases

__END__

=pod

=head1 SYNOPSIS

    use 5.008;

    use GeoIP2::Database::Reader

    my $reader = GeoIP2::Database::Reader->new(
        file      => '/path/to/database',
        languages => [ 'en', 'de', ]
    );

    my $omni = $reader->omni( ip => '24.24.24.24' );
    my $country = $omni->country();
    say $country->is_code();

=head1 DESCRIPTION

This class provides a reader API for all GeoIP2 databases.  The methods
provided by this reader (C<country()>, C<city()>, C<city_isp_org()> and
C<omni()>), correspond to the web service endpoints (Country, City,
City/ISP/Org, and Omni). Each method returns a different set of data about an
IP address, with country returning the least data and omni the most.

Each method returns a different model class, and these model classes in turn
contain multiple record classes. The record classes have attributes which
contain data about the IP address.

If the database does not return a particular piece of data for an IP address,
the associated attribute is not populated.

The database may not return any information for an entire record, in which case
all of the attributes for that record class will be empty.

=head1 USAGE

The basic API for this class is the same for all database types.  First you
create a database reader object with your C<file> and C<language> params.
Then you call the method corresponding to your database type, passing it the
IP address you want to look up.

If the request succeeds, the method call will return a model class for the
method point you called. This model, in turn, contains multiple record classes,
each of which represents part of the data returned by the database.

If the database cannot be read, the reader class throws an exception.

=head1 CONSTRUCTOR

This class has a single constructor method:

=head2 GeoIP2::Database::Reader->new()

This method creates a new object. It accepts the following arguments:

=over 4

=item * file

This is the path to the GeoIP2 database file which you'd like to query.

=item * languages

This is an array reference where each value is a string indicating a language.
This argument will be passed on to record classes to use when their C<name()>
methods are called.

The order of the languages is significant. When a record class has multiple
names (country, city, etc.), its C<name()> method will look at each element of
this array ref and return the first language for which it has a name.

Note that the only language which is always present in the GeoIP2 data in
"en". If you do not include this language, the C<name()> method may end up
returning C<undef> even when the record in question has an English name.

Currently, the valid list of language codes is:

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

Passing any other language code will result in an error.

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

=head2 $client->country()

This method returns a L<GeoIP2::Model::Country> object.

=head2 $client->city()

This method returns a L<GeoIP2::Model::City> object.

=head2 $client->city_isp_org()

This method returns a L<GeoIP2::Model::CityISPOrg> object.

=head2 $client->omni()

This method returns a L<GeoIP2::Model::Omni> object.

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

See L<http://dev.maxmind.com/geoip/geoip2/web-services> for details on what data each end
point I<may> return.

The only piece of data which is always returned is the C<ip_address> key in
the C<GeoIP2::Record::Traits> record.

Every record class attribute has a corresponding predicate method so you can
check to see if the attribute is set.

=cut
