package GeoIP2::Webservice::Client;

use strict;
use warnings;

use Data::Validate::IP qw( is_public_ipv4 );
use GeoIP2::Error::HTTP;
use GeoIP2::Error::JSON;
use GeoIP2::Error::Webservice;
use GeoIP2::Model::City;
use GeoIP2::Model::Country;
use GeoIP2::Model::Omni;
use GeoIP2::Types
    qw( JSONObject MaxMindID MaxMindLicenseKey URIObject URIObjectCoercion UserAgentObject );
use JSON;
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

has use_ssl => (
    is      => 'ro',
    default => quote_sub(q{ 1 }),
);

has base_uri => (
    is      => 'ro',
    isa     => URIObject,
    coerce  => URIObjectCoercion,
    lazy    => 1,
    default => quote_sub(
        q{ my $scheme = $_[0]->use_ssl() ? 'https' : 'http';
           return URI->new("$scheme://geoip.maxmind.com/geoip") }
    ),
);

has ua => (
    is      => 'ro',
    isa     => UserAgentObject,
    default => quote_sub(q{ LWP::UserAgent->new() }),
);

has _json => (
    is       => 'ro',
    isa      => JSONObject,
    init_arg => undef,
    default  => quote_sub(q{ JSON->new()->utf8() }),
);

my %ip_param = (
    ip => {
        callbacks => {
            'is a public IP address' => sub { is_public_ipv4( $_[0] ) }
        },
    },
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

sub omni {
    my $self = shift;

    return $self->_response_for(
        'omni',
        'GeoIP2::Model::Omni',
        @_,
    );
}

sub _response_for {
    my $self        = shift;
    my $path        = shift;
    my $model_class = shift;

    state $spec = {%ip_param};
    my %p = validate( @_, $spec );

    my $uri = $self->uri();
    $uri->path_pieces( $uri->path_pieces(), $path, $p{ip} );

    my $response = $self->ua()->get($uri);

    if ( $response->code() == 200 ) {
        my $body = $self->_handle_success( $response, $uri );
        return $model_class->new(
            raw       => $body,
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
        $body = $json->decode( $response->content() );
    }
    catch {
        GeoIP2::Error::Generic->throw(
            error =>
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

    my $body;
    try {
        $body = $json->decode( $response->content() );
        die
            'Response contains JSON but it does not specify code or error keys'
            unless $body->{code} && $body->{error};
    }
    catch {
        GeoIP2::Error::HTTP->throw(
            http_status => $status,
            error =>
                "Received a $status error for $uri but it did not include the expected JSON body: $_",
            uri => $uri,
        );
    };

    GeoIP2::Error::Webservice->throw(
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
        error       => "Received a server error ($status) for $uri",
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
        error => "Received a very surprising HTTP status ($status) for $uri",
        http_status => $status,
        uri         => $uri,
    );
}

1;
