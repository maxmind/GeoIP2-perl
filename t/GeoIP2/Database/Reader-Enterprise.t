use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Number::Delta;

use GeoIP2::Database::Reader;
use Path::Class qw( file );

{
    my $reader
        = GeoIP2::Database::Reader->new(
        file => file(qw( maxmind-db test-data GeoIP2-Enterprise-Test.mmdb ))
        );

    my $ip_address = '74.209.16.1';
    my $enterprise = $reader->enterprise( ip => $ip_address );

    subtest city => sub {
        my $item = $enterprise->city;
        is( $item->confidence, 11, 'confidence' );
        is_deeply(
            $item->names,
            {
                en => 'Chatham',
            },
            'names'
        );
        is( $item->geoname_id, 5112335, 'geoname_id' );
    };

    subtest continent => sub {
        my $item = $enterprise->continent;
        is( $item->geoname_id, 6255149, 'geoname_id' );
        is( $item->code,       'NA',    'code' );
        is_deeply(
            $item->names,
            {
                'ja' => "\x{5317}\x{30a2}\x{30e1}\x{30ea}\x{30ab}",
                'ru' =>
                    "\x{0421}\x{0435}\x{0432}\x{0435}\x{0440}\x{043d}\x{0430}\x{044f} \x{0410}\x{043c}\x{0435}\x{0440}\x{0438}\x{043a}\x{0430}",
                'en'    => 'North America',
                'fr'    => "Am\x{e9}rique du Nord",
                'de'    => 'Nordamerika',
                'es'    => "Norteam\x{e9}rica",
                'pt-BR' => "Am\x{e9}rica do Norte",
                'zh-CN' => "\x{5317}\x{7f8e}\x{6d32}"
            },
            'names'
        );
    };

    subtest country => sub {
        my $item = $enterprise->country;
        is_deeply(
            $item->names,
            {
                'ja' =>
                    "\x{30a2}\x{30e1}\x{30ea}\x{30ab}\x{5408}\x{8846}\x{56fd}",
                'ru'    => "\x{0421}\x{0428}\x{0410}",
                'en'    => 'United States',
                'fr'    => "\x{c9}tats-Unis",
                'de'    => 'USA',
                'pt-BR' => 'Estados Unidos',
                'es'    => 'Estados Unidos',
                'zh-CN' => "\x{7f8e}\x{56fd}"
            },
            'names'
        );
        is( $item->confidence, 99,      'confidence' );
        is( $item->iso_code,   'US',    'iso_code' );
        is( $item->geoname_id, 6252001, 'geoname_id' );
    };

    subtest location => sub {
        my $item = $enterprise->location;
        delta_ok( $item->longitude, -73.5549, 'longitude' );
        delta_ok( $item->latitude,  42.3478,  'latitude' );
        is( $item->accuracy_radius, 27,                 'accuracy_radius' );
        is( $item->metro_code,      532,                'metro_code' );
        is( $item->time_zone,       'America/New_York', 'time_zone' );
    };

    subtest postal => sub {
        my $item = $enterprise->postal;
        is( $item->confidence, 11,      'confidence' );
        is( $item->code,       '12037', 'code' );
    };

    subtest registered_country => sub {
        my $item = $enterprise->registered_country;
        is( $item->iso_code, 'US', 'iso_code' );
        is_deeply(
            $item->names,
            {
                'en' => 'United States',
                'fr' => "\x{c9}tats-Unis",
                'ru' => "\x{0421}\x{0428}\x{0410}",
                'ja' =>
                    "\x{30a2}\x{30e1}\x{30ea}\x{30ab}\x{5408}\x{8846}\x{56fd}",
                'zh-CN' => "\x{7f8e}\x{56fd}",
                'pt-BR' => 'Estados Unidos',
                'de'    => 'USA',
                'es'    => 'Estados Unidos'
            },
            'names'
        );
        is( $item->geoname_id, 6252001, 'geoname_id' );
    };

    subtest subdivisions => sub {
        my $item = $enterprise->most_specific_subdivision;
        is_deeply(
            $item->names,
            {
                'zh-CN' => "\x{7ebd}\x{7ea6}\x{5dde}",
                'es'    => 'Nueva York',
                'pt-BR' => 'Nova Iorque',
                'de'    => 'New York',
                'ru' =>
                    "\x{041d}\x{044c}\x{044e}-\x{0419}\x{043e}\x{0440}\x{043a}",
                'en' => 'New York',
                'fr' => 'New York',
                'ja' =>
                    "\x{30cb}\x{30e5}\x{30fc}\x{30e8}\x{30fc}\x{30af}\x{5dde}",
            },
            'names'
        );
        is( $item->confidence, 93,      'confidence' );
        is( $item->iso_code,   'NY',    'iso_code' );
        is( $item->geoname_id, 5128638, 'geoname_id' );
    };

    subtest traits => sub {
        my $item = $enterprise->traits;
        is(
            $item->autonomous_system_number, 14671,
            'autonomous_system_number'
        );
        is(
            $item->autonomous_system_organization,
            'FairPoint Communications', 'autonomous_system_organization'
        );
        is( $item->connection_type,     'Cable/DSL', 'connection_type' );
        is( $item->domain,              'frpt.net',  'domain' );
        is( $item->is_anonymous_proxy,  1,           'is_anonymous_proxy' );
        is( $item->is_legitimate_proxy, 1,           'is_legitimate_proxy' );
        is( $item->is_satellite_provider, 1, 'is_satellite_provider' );
        is( $item->isp,          'Fairpoint Communications', 'isp' );
        is( $item->organization, 'Fairpoint Communications', 'organization' );
        is( $item->user_type,    'residential',              'user_type' );
    };
}

done_testing();
