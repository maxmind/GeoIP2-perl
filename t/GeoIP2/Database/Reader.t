use strict;
use warnings;

use Test::More;
use Test::Fatal;

use GeoIP2::Database::Reader;
use Path::Class::File;

my $file = 't/test-data/GeoIP2-Precision-City.mmdb';

my $languages = [ 'en', 'de', ];

foreach my $file_name ( 'GeoIP2-Precision-City.mmdb', 'GeoIP2-City.mmdb' ) {
    test_file( $file_name );
}

sub test_file {
    my $file_name = shift;
    my $reader    = GeoIP2::Database::Reader->new(
        file      => Path::Class::File->new( 't', 'test-data', $file_name ),
        languages => $languages
    );

    ok( $reader, 'got reader for ' . $file_name );

    foreach my $endpoint ( 'country', 'city', 'city_isp_org', 'omni' ) {
        like(
            exception { $reader->$endpoint() },
            qr/Required param/,
            'dies on missing ip'
        );

        like(
            exception { $reader->$endpoint( ip => 'me' ) },
            qr/me is not a valid lookup IP/,
            'dies on "me"'
        );

        like(
            exception { $reader->$endpoint( ip => 'x' ) },
            qr/me is not a valid lookup IP/,
            'dies on invalid ip'
        );

        my $ip = '81.2.69.160';
        my $omni = $reader->$endpoint( ip => $ip );

        is( $omni->country->name,
            'United Kingdom',
            'country name for ' . $endpoint
        );
        next if $endpoint eq 'country';

        is( $omni->city->name, 'London', 'city name for ' . $endpoint );
    }
}

done_testing();
