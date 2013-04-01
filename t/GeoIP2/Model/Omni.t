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
            confidence         => 99,
            geoname_id         => 1,
            iso_3166_1_alpha_2 => 'US',
            iso_3166_1_alpha_3 => 'USA',
            names              => { en => 'United States of America' },
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
        region => {
            confidence => 88,
            geoname_id => 574635,
            iso_3166_2 => 'MN',
            names      => { en => 'Minnesota' },
        },
        registered_country => {
            geoname_id         => 2,
            iso_3166_1_alpha_2 => 'CA',
            iso_3166_1_alpha_3 => 'CAN',
            names              => { en => 'Canada' },
        },
        traits => {
            autonomous_system_number       => 1234,
            autonomous_system_organization => 'AS Organization',
            domain                         => 'example.com',
            ip_address                     => '1.2.3.4',
            is_anonymous_proxy             => 0,
            is_transparent_proxy           => 1,
            is_us_military                 => 1,
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
        $model->region(),
        'GeoIP2::Record::Region',
        '$model->region()'
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
    my $model = GeoIP2::Model::Omni->new(
        traits => { ip_address => '5.6.7.8' } );

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
        $model->region(),
        'GeoIP2::Record::Region',
        '$model->region()'
    );

    isa_ok(
        $model->traits(),
        'GeoIP2::Record::Traits',
        '$model->traits()'
    );
}

done_testing();
