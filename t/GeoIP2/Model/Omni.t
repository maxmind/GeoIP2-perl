use strict;
use warnings;

use Test::Fatal;
use Test::More 0.88;

use GeoIP2::Model::Omni;

{
    my %raw = (
        city => {
            confidence => 76,
            geoname_id => 9876,
            names      => { en => 'Minneapolis' },
        },
        continent => {
            continent_code => 'NA',
            geoname_id     => 42,
            names          => { en => 'North America' },
        },
        country => {
            confidence => 99,
            geoname_id => 1,
            iso_code   => 'US',
            names      => {
                'de'    => 'Nordamerika',
                'en'    => 'North America',
                'ja'    => '北米',
                'es'    => 'América del Norte',
                'fr'    => 'Amérique du Nord',
                'ja'    => '北アメリカ',
                'pt-BR' => 'América do Norte',
                'ru'    => 'Северная Америка',
                'zh-CN' => '北美洲',
            },
        },
        location => {
            accuracy_radius   => 1500,
            latitude          => 44.98,
            longitude         => 93.2636,
            metro_code        => 765,
            postal_code       => '55401',
            postal_confidence => 33,
            time_zone         => 'America/Chicago',
        },
        registered_country => {
            geoname_id => 2,
            iso_code   => 'CA',
            names      => { en => 'Canada' },
        },
        represented_country => {
            geoname_id => 3,
            iso_code   => 'GB',
            names      => { en => 'United Kingdom' },
        },
        subdivisions => [
            {
                confidence => 88,
                geoname_id => 574635,
                iso_code   => 'MN',
                names      => { en => 'Minnesota' },
            }
        ],
        traits => {
            autonomous_system_number       => 1234,
            autonomous_system_organization => 'AS Organization',
            domain                         => 'example.com',
            ip_address                     => '1.2.3.4',
            is_satellite_provider          => 1,
            isp                            => 'Comcast',
            organization                   => 'Blorg',
            user_type                      => 'college',
        },
    );

    my $model = GeoIP2::Model::Omni->new(%raw);

    isa_ok(
        $model,
        'GeoIP2::Model::Omni',
        'GeoIP2::Model::Omni object'
    );

    isa_ok(
        $model->city(),
        'GeoIP2::Record::City',
        '$model->city()'
    );

    isa_ok(
        $model->continent(),
        'GeoIP2::Record::Continent',
        '$model->continent()'
    );

    isa_ok(
        $model->country(),
        'GeoIP2::Record::Country',
        '$model->country()'
    );

    isa_ok(
        $model->location(),
        'GeoIP2::Record::Location',
        '$model->location()'
    );

    isa_ok(
        $model->registered_country(),
        'GeoIP2::Record::Country',
        '$model->registered_country()'
    );

    isa_ok(
        $model->represented_country(),
        'GeoIP2::Record::RepresentedCountry',
        '$model->represented_country()'
    );

    my @subdivisions = $model->subdivisions();
    for my $i ( 0 .. $#subdivisions ) {
        isa_ok(
            $subdivisions[$i],
            'GeoIP2::Record::Subdivision',
            "\$model->subdivisions()[$i]"
        );
    }

    isa_ok(
        $model->most_specific_subdivision(),
        'GeoIP2::Record::Subdivision',
        '$model->most_specific_subdivision',
    );

    isa_ok(
        $model->traits(),
        'GeoIP2::Record::Traits',
        '$model->traits()'
    );

    is_deeply(
        $model->raw(),
        \%raw,
        'raw method returns raw input'
    );
}

{
    my %raw = ( traits => { ip_address => '5.6.7.8' } );

    my $model = GeoIP2::Model::Omni->new(%raw);

    isa_ok(
        $model,
        'GeoIP2::Model::Omni',
        'GeoIP2::Model::Omni object with no data except traits.ip_address'
    );

    isa_ok(
        $model->city(),
        'GeoIP2::Record::City',
        '$model->city()'
    );

    isa_ok(
        $model->continent(),
        'GeoIP2::Record::Continent',
        '$model->continent()'
    );

    isa_ok(
        $model->country(),
        'GeoIP2::Record::Country',
        '$model->country()'
    );

    isa_ok(
        $model->location(),
        'GeoIP2::Record::Location',
        '$model->location()'
    );

    isa_ok(
        $model->registered_country(),
        'GeoIP2::Record::Country',
        '$model->registered_country()'
    );

    isa_ok(
        $model->represented_country(),
        'GeoIP2::Record::RepresentedCountry',
        '$model->represented_country()'
    );

    my @subdivisions = $model->subdivisions();
    is(
        scalar $model->subdivisions(),
        0,
        '$model->subdivisions returns an empty list'
    );

    isa_ok(
        $model->most_specific_subdivision(),
        'GeoIP2::Record::Subdivision',
        '$model->most_specific_subdivision',
    );

    isa_ok(
        $model->traits(),
        'GeoIP2::Record::Traits',
        '$model->traits()'
    );

    is_deeply(
        $model->raw(),
        \%raw,
        'raw method returns raw input with no added empty values'
    );
}

{
    my %raw = (
        new_top_level => { foo => 42 },
        city          => {
            confidence => 76,
            geoname_id => 9876,
            names      => { en => 'Minneapolis' },
            population => 50,
        },
        traits => { ip_address => '5.6.7.8' },
    );

    my $model;
    is(
        exception { $model = GeoIP2::Model::Omni->new(%raw) },
        undef,
        'no exception when Omni model gets raw data with unknown keys'
    );

    is_deeply(
        $model->raw(),
        \%raw,
        'raw method returns raw input'
    );
}

done_testing();
