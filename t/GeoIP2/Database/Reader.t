use strict;
use warnings;

use Test::More;
use Test::Fatal;

use GeoIP2::Database::Reader;
use Path::Class qw( file );

my $languages = [ 'en', 'de', ];

{
    my $reader = GeoIP2::Database::Reader->new(
        file =>
            file(qw( maxmind-db test-data GeoIP2-City-Test.mmdb))->stringify,
        languages => $languages
    );

    ok( $reader, 'got reader for test database' );

    foreach my $method ( 'country', 'city', 'city_isp_org', 'omni' ) {
        like(
            exception { $reader->$method() },
            qr/Required param/,
            "dies on missing ip - $method method"
        );

        like(
            exception { $reader->$method( ip => 'me' ) },
            qr/me is not a valid IP/,
            qq{dies on "me" - $method method}
        );

        like(
            exception { $reader->$method( ip => '9.10.11.12' ) },
            qr/\QNo record found for IP address 9.10.11.12/,
            "dies if IP is not in database - $method method"
        );

        like(
            exception { $reader->$method( ip => 'x' ) },
            qr/\QThe IP address you provided (x) is not a valid IPv4 or IPv6 address/,
            "dies on invalid ip - $method method"
        );

        my $ip = '81.2.69.160';
        my $model = $reader->$method( ip => $ip );

        is(
            $model->country->name,
            'United Kingdom',
            "country name - $method method"
        );

        is(
            $model->traits->ip_address,
            '81.2.69.160',
            "ip address is filled in - $method method"
        );

        next if $method eq 'country';

        is( $model->city->name, 'London', "city name - $method method" );
    }
}

done_testing();
