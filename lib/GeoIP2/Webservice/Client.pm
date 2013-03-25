package GeoIP2::Webservice::Client;

use v5.10;

use strict;
use warnings;

use Data::Validate::IP qw( is_public_ipv4 );
use GeoIP2::Error::Generic;
use GeoIP2::Error::HTTP;
use GeoIP2::Error::Webservice;
use GeoIP2::Model::City;
use GeoIP2::Model::CityISPOrg;
use GeoIP2::Model::Country;
use GeoIP2::Model::Omni;
use GeoIP2::Types
    qw( JSONObject MaxMindID MaxMindLicenseKey Str URIObject UserAgentObject );
use JSON;
use MIME::Base64 qw( encode_base64 );
use LWP::Protocol::https;
use LWP::UserAgent;
use Params::Validate qw( validate );
use Sub::Quote qw( quote_sub );
use Try::Tiny;
use URI;

use Moo;

with 'GeoIP2::Role::HasLanguages';

has user_id => (
    is       => 'ro',
    isa      => MaxMindID,
    required => 1,
);

has license_key => (
    is       => 'ro',
    isa      => MaxMindLicenseKey,
    required => 1,
);

has host => (
    is      => 'ro',
    isa     => Str,
    default => quote_sub(q{ 'geoip.maxmind.com' }),
);

has ua => (
    is      => 'ro',
    isa     => UserAgentObject,
    builder => '_build_ua',
);

has _base_uri => (
    is      => 'ro',
    isa     => URIObject,
    lazy    => 1,
    builder => '_build_base_uri',
);

has _json => (
    is       => 'ro',
    isa      => JSONObject,
    init_arg => undef,
    default  => quote_sub(q{ JSON->new()->utf8() }),
);

sub country {
    my $self = shift;

    return $self->_response_for(
        'country',
        'GeoIP2::Model::Country',
        @_,
    );
}

sub city {
    my $self = shift;

    return $self->_response_for(
        'city',
        'GeoIP2::Model::City',
        @_,
    );
}

sub city_isp_org {
    my $self = shift;

    return $self->_response_for(
        'city_isp_org',
        'GeoIP2::Model::CityISPOrg',
        @_,
    );
}

sub omni {
    my $self = shift;

    return $self->_response_for(
        'omni',
        'GeoIP2::Model::Omni',
        @_,
    );
}

my %ip_param = (
    ip => {
        callbacks => {
            'is a public IP address or me' => sub {
                return defined $_[0]
                    && ( $_[0] eq 'me' || is_public_ipv4( $_[0] ) );
                }
        },
    },
);

sub _response_for {
    my $self        = shift;
    my $path        = shift;
    my $model_class = shift;

    state $spec = {%ip_param};
    my %p = validate( @_, $spec );

    my $uri = $self->_base_uri()->clone();
    $uri->path_segments( $uri->path_segments(), $path, $p{ip} );

    my $request = HTTP::Request->new(
        'GET', $uri,
        HTTP::Headers->new( Accept => 'application/json' ),
    );

    $request->authorization_basic( $self->user_id(), $self->license_key() );

    my $response = $self->ua()->request($request);

    if ( $response->code() == 200 ) {
        my $body = $self->_handle_success( $response, $uri );
        return $model_class->new(
            %{$body},
            languages => $self->languages(),
        );
    }
    else {
        # all other error codes throw an exception
        $self->_handle_error_status( $response, $uri );
    }
}

sub _handle_success {
    my $self     = shift;
    my $response = shift;
    my $uri      = shift;

    my $body;
    try {
        $body = $self->_json()->decode( $response->content() );
    }
    catch {
        GeoIP2::Error::Generic->throw(
            message =>
                "Received a 200 response for $uri but could not decode the response as JSON: $_",
        );
    };

    return $body;
}

sub _handle_error_status {
    my $self     = shift;
    my $response = shift;
    my $uri      = shift;

    my $status = $response->code();

    if ( $status =~ /^4/ ) {
        $self->_handle_4xx_status( $response, $status, $uri );
    }
    elsif ( $status =~ /^5/ ) {
        $self->_handle_5xx_status( $response, $status, $uri );
    }
    else {
        $self->_handle_non_200_status( $response, $status, $uri );
    }
}

sub _handle_4xx_status {
    my $self     = shift;
    my $response = shift;
    my $status   = shift;
    my $uri      = shift;

    my $content = $response->content();

    my $body = {};

    if ( defined $content && length $content ) {
        try {
            $body = $self->_json()->decode($content);
            die
                'Response contains JSON but it does not specify code or error keys'
                unless $body->{code} && $body->{error};
        }
        catch {
            GeoIP2::Error::HTTP->throw(
                message =>
                    "Received a $status error for $uri but it did not include the expected JSON body: $_",
                http_status => $status,
                uri         => $uri,
            );
        };
    }
    else {
        GeoIP2::Error::HTTP->throw(
            message     => "Received a $status error for $uri with no body",
            http_status => $status,
            uri         => $uri,
        );
    }

    GeoIP2::Error::Webservice->throw(
        message => delete $body->{error},
        %{$body},
        http_status => $status,
        uri         => $uri,
    );
}

sub _handle_5xx_status {
    my $self     = shift;
    my $response = shift;
    my $status   = shift;
    my $uri      = shift;

    GeoIP2::Error::HTTP->throw(
        message     => "Received a server error ($status) for $uri",
        http_status => $status,
        uri         => $uri,
    );
}

sub _handle_non_200_status {
    my $self     = shift;
    my $response = shift;
    my $status   = shift;
    my $uri      = shift;

    GeoIP2::Error::HTTP->throw(
        message =>
            "Received a very surprising HTTP status ($status) for $uri",
        http_status => $status,
        uri         => $uri,
    );
}

sub _build_base_uri {
    my $self = shift;

    return URI->new( 'https://' . $self->host() . '/geoip' );
}

sub _build_ua {
    my $self = shift;

    return LWP::UserAgent->new();
}

1;
