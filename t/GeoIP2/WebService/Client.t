use strict;
use warnings;

use Test::Fatal;
use Test::More 0.88;

use GeoIP2::WebService::Client;
use HTTP::Headers;
use HTTP::Response;
use HTTP::Status qw( status_message );
use IO::Compress::Gzip qw( gzip $GzipError );
use JSON::MaybeXS;

my $json = JSON::MaybeXS->new( utf8 => 1 );

my %country = (
    continent => {
        code       => 'NA',
        geoname_id => 42,
        names      => { en => 'North America' },
    },
    country => {
        geoname_id => 1,
        iso_code   => 'US',
        names      => { en => 'United States of America' },
    },
    traits => {
        ip_address => '1.2.3.4',
        ## no critic (Subroutines::ProhibitCallsToUnexportedSubs)
        is_anonymous_proxy => JSON->true
            ## use critic
    },
);

my %responses = (
    '1.2.3.4' => _response(
        'country',
        200,
        \%country,
    ),
    me => _response(
        'country',
        200,
        \%country,
    ),
    'a09c:4242:519c::0123' => _response(
        'country',
        200,
        \%country,
    ),
    '1.2.3.5' => _response(
        'country',
        200,
    ),
    '1.2.3.6' => _response(
        'error', 400,
        {
            code  => 'IP_ADDRESS_INVALID',
            error => q{The value "1.2.3" is not a valid ip address},
        },
    ),
    '1.2.3.7' => _response(
        'error',
        400,
    ),
    '1.2.3.8' => _response(
        'error',
        400,
        { weird => 42 },
    ),
    '1.2.3.9' => _response(
        'error',
        400,
        undef,
        'bad body',
    ),
    '1.2.3.10' => _response(
        undef,
        500,
    ),
    '1.2.3.11' => _response(
        undef,
        300,
    ),
    '1.2.3.12' => _response(
        'error',
        406,
        'Cannot satisfy your Accept-Charset requirements',
        undef,
        'text/plain',
    ),
    '1.2.3.13' => _response(
        'country',
        200,
        \%country,
        0,
        undef,
        'gzip',
    ),
    '1.2.3.14' => _response(
        'error', 404,
        {
            code => 'IP_ADDRESS_NOT_FOUND',
            error =>
                q{The ip address "1.2.3.14" was not found in our database},
        },
    ),
);

my $ua = Mock::LWP::UserAgent->new(
    sub {
        my $self    = shift;
        my $request = shift;

        my ($ip) = $request->uri() =~ m{country/(.+)$};

        return $responses{$ip};
    }
);

{
    my $client = GeoIP2::WebService::Client->new(
        user_id     => 42,
        license_key => 'abcdef123456',
        ua          => $ua,
    );

    my $country = $client->country( ip => '1.2.3.4' );
    isa_ok(
        $country,
        'GeoIP2::Model::Country',
        'return value of $client->country'
    );

    is(
        $country->traits->is_anonymous_proxy,
        1,
        'is_anonymous_proxy is 1'
    );

    is(
        $country->continent()->geoname_id(),
        42,
        'continent geoname_id is 42'
    );

    is(
        $country->continent()->code(),
        'NA',
        'continent code is NA'
    );

    is_deeply(
        $country->continent()->names(),
        { en => 'North America' },
        'continent names'
    );

    is(
        $country->continent()->name(),
        'North America',
        'continent name is North America'
    );

    is(
        $country->country()->geoname_id(),
        1,
        'country geoname_id is 1'
    );

    is(
        $country->country()->iso_code(),
        'US',
        'country iso_code is US'
    );

    is_deeply(
        $country->country()->names(),
        { en => 'United States of America' },
        'country names'
    );

    is(
        $country->country()->name(),
        'United States of America',
        'country name is United States of America'
    );

    my $ipv6_country = $client->country( ip => 'a09c:4242:519c::0123' );
    isa_ok(
        $ipv6_country,
        'GeoIP2::Model::Country',
        'return value of $client->country for IPv6 address'
    );

    my $gzip_country = $client->country( ip => '1.2.3.13' );
    isa_ok(
        $gzip_country,
        'GeoIP2::Model::Country',
        'return value of $client->country with gzipped response'
    );
}

{
    my $client = GeoIP2::WebService::Client->new(
        user_id     => 42,
        license_key => 'abcdef123456',
        ua          => $ua,
    );

    ok(
        $client->country( ip => 'me' ),
        'can set ip parameter to me'
    );
}

{
    my $client = GeoIP2::WebService::Client->new(
        user_id     => 42,
        license_key => 'abcdef123456',
        ua          => $ua,
    );

    my $e = exception { $client->country( ip => '1.2.3.5' ) };
    isa_ok(
        $e,
        'GeoIP2::Error::Generic',
        'exception thrown when response status is 200 but body is not valid JSON'
    );

    like(
        $e->message(),
        qr/could not decode the response as JSON/,
        'error contains expected text'
    );
}

{
    my $client = GeoIP2::WebService::Client->new(
        user_id     => 42,
        license_key => 'abcdef123456',
        ua          => $ua,
    );

    my $e = exception { $client->country( ip => '1.2.3.6' ) };
    isa_ok(
        $e,
        'GeoIP2::Error::WebService',
        'exception thrown when web service returns a 4xx error'
    );

    is(
        $e->code(),
        'IP_ADDRESS_INVALID',
        'exception object contains expected code'
    );

    is(
        $e->http_status(),
        400,
        'exception object contains expected http_status'
    );

    like(
        $e->message(),
        qr/\QThe value "1.2.3" is not a valid ip address/,
        'error contains expected text'
    );
}

{
    my $client = GeoIP2::WebService::Client->new(
        user_id     => 42,
        license_key => 'abcdef123456',
        ua          => $ua,
    );

    my $e = exception { $client->country( ip => '1.2.3.7' ) };
    isa_ok(
        $e,
        'GeoIP2::Error::HTTP',
        'exception thrown when web service returns a 4xx error without a body'
    );

    like(
        $e->message(),
        qr/\QReceived a 400 error for \E.+\Q with no body/,
        'error contains expected text'
    );
}

{
    my $client = GeoIP2::WebService::Client->new(
        user_id     => 42,
        license_key => 'abcdef123456',
        ua          => $ua,
    );

    my $e = exception { $client->country( ip => '1.2.3.8' ) };
    isa_ok(
        $e,
        'GeoIP2::Error::HTTP',
        'exception thrown when web service returns a 4xx error with a JSON body but no code and error keys'
    );

    like(
        $e->message(),
        qr/\Qit did not include the expected JSON body: Response contains JSON but it does not specify code or error keys/,
        'error contains expected text'
    );
}

{
    my $client = GeoIP2::WebService::Client->new(
        user_id     => 42,
        license_key => 'abcdef123456',
        ua          => $ua,
    );

    my $e = exception { $client->country( ip => '1.2.3.9' ) };
    isa_ok(
        $e,
        'GeoIP2::Error::HTTP',
        'exception thrown when web service returns a 4xx error with a non-JSON body'
    );

    like(
        $e->message(),
        qr/\Qit did not include the expected JSON body:/,
        'error contains expected text'
    );
}

{
    my $client = GeoIP2::WebService::Client->new(
        user_id     => 42,
        license_key => 'abcdef123456',
        ua          => $ua,
    );

    my $e = exception { $client->country( ip => '1.2.3.10' ) };
    isa_ok(
        $e,
        'GeoIP2::Error::HTTP',
        'exception thrown when web service returns a 5xx error'
    );

    like(
        $e->message(),
        qr/\QReceived a server error (500) for \E.+/,
        'error contains expected text'
    );
}

{
    my $client = GeoIP2::WebService::Client->new(
        user_id     => 42,
        license_key => 'abcdef123456',
        ua          => $ua,
    );

    my $e = exception { $client->country( ip => '1.2.3.11' ) };
    isa_ok(
        $e,
        'GeoIP2::Error::HTTP',
        'exception thrown when web service returns a 3xx error'
    );

    like(
        $e->message(),
        qr/\QReceived a very surprising HTTP status (300) for \E.+/,
        'error contains expected text'
    );
}

{
    my $test_ua = Mock::LWP::UserAgent->new(
        sub {
            my $self    = shift;
            my $request = shift;

            is(
                $request->uri(),
                'https://geoip.maxmind.com/geoip/v2.1/country/1.2.3.4',
                'got expected URI for Country request'
            );

            is(
                $request->method(),
                'GET',
                'request is a GET'
            );

            is(
                $request->header('Accept'),
                'application/json',
                'request sets Accept header to application/json'
            );

            return _response(
                'country',
                200,
                \%country,
            );
        }
    );

    my $client = GeoIP2::WebService::Client->new(
        user_id     => 42,
        license_key => 'abcdef123456',
        ua          => $test_ua,
    );

    $client->country( ip => '1.2.3.4' );

}

{
    local $GeoIP2::WebService::Client::VERSION = 42;
    my $client = GeoIP2::WebService::Client->new(
        user_id     => 42,
        license_key => 'abcdef123456',
    );

    like(
        $client->ua()->agent(),
        qr/\QGeoIP2::WebService::Client v42/,
        'user agent includes client package and version'
    );

    my $ua_version = $client->ua()->VERSION();

    like(
        $client->ua()->agent(),
        qr/\QLWP::UserAgent v$ua_version/,
        'user agent includes user agent package and version'
    );

    like(
        $client->ua()->agent(),
        qr/\QPerl $^V/,
        'user agent includes Perl version'
    );
}

{
    my $client = GeoIP2::WebService::Client->new(
        user_id     => 42,
        license_key => 'abcdef123456',
        ua          => $ua,
    );

    my $e = exception { $client->country( ip => '1.2.3.12' ) };
    isa_ok(
        $e,
        'GeoIP2::Error::HTTP',
        'exception thrown when web service returns a 406 error'
    );

    like(
        $e->message(),
        qr{\QReceived a 406 error for https://geoip.maxmind.com/geoip/v2.1/country/1.2.3.12 with the following body: Cannot satisfy your Accept-Charset requirements},
        'error contains expected text'
    );

    unlike(
        $e->message(),
        qr/\QResponse contains JSON/,
        'error does not complain about JSON issues when Content-Type for error is text/plain'
    );
}

{
    my $client = GeoIP2::WebService::Client->new(
        user_id     => 42,
        license_key => 'abcdef123456',
    );

    my @bad = qw(
        mine
        0.1.2.3
        255.666.242.1
        abcd::1234::b6b3
        1.2.3
        abcde::
    );

    for my $bad (@bad) {
        like(
            exception { $client->country( ip => $bad ) },
            qr/is a public IP address or me/,
            qq{client rejects ip address '$bad'}
        );
    }
}

{
    my $client = GeoIP2::WebService::Client->new(
        user_id     => 42,
        license_key => 'abcdef123456',
        ua          => $ua,
    );

    my $e = exception { $client->country( ip => '1.2.3.14' ) };
    isa_ok(
        $e,
        'GeoIP2::Error::IPAddressNotFound',
        'error thrown when IP address cannot be found'
    );

    is(
        $e->ip_address,
        '1.2.3.14',
        'exception ip_address() method returns the IP address'
    );
}

done_testing();

{
    package Mock::LWP::UserAgent;

    use strict;
    use warnings;

    use base 'LWP::UserAgent';

    sub new {
        my $class        = shift;
        my $request_meth = shift;

        my $self = $class->SUPER::new();

        $self->{__request_meth__} = $request_meth;

        return $self;
    }

    sub request {
        my $self = shift;

        my $meth = $self->{__request_meth__};

        return $self->$meth(@_);
    }

    sub VERSION {
        return 1;
    }
}

sub _response {
    my $endpoint     = shift;
    my $status       = shift;
    my $body         = shift;
    my $bad          = shift;
    my $content_type = shift;
    my $gzip         = shift;

    my $headers = HTTP::Headers->new();

    if ($content_type) {
        $headers->header( 'Content-Type' => $content_type );
    }
    elsif ( $status == 200 || ( $status >= 400 && $status < 500 ) ) {
        $headers->header( 'Content-Type' => 'application/vnd.maxmind.com-'
                . $endpoint
                . '+json; charset=UTF-8; version=1.0' );
    }

    my $encoded_body = q{};
    if ($bad) {
        $encoded_body = '{ invalid: }';
    }
    elsif ($body) {
        $encoded_body = ref $body ? $json->encode($body) : $body;
    }

    if ($gzip) {
        $headers->header( 'Content-Encoding', 'gzip' );

        my $gzipped;
        gzip( \$encoded_body => \$gzipped )
            or die "gzip failed: $GzipError";
        $encoded_body = $gzipped;
    }

    return HTTP::Response->new(
        $status,
        status_message($status),
        $headers,
        $encoded_body,
    );
}
