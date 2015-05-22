use strict;
use warnings;

use lib 't/lib';

use Test::GeoIP2 qw(
    test_model_class
    test_model_class_with_empty_record
    test_model_class_with_unknown_keys
);
use Test::More 0.88;

use GeoIP2::Model::Insights;

{
    my %raw = (
        city => {
            confidence => 76,
            geoname_id => 9876,
            names      => { en => 'Minneapolis' },
        },
        continent => {
            code       => 'NA',
            geoname_id => 42,
            names      => { en => 'North America' },
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
            average_income       => 12345,
            accuracy_radius      => 1500,
            estimated_population => 45678,
            latitude             => 44.98,
            longitude            => 93.2636,
            metro_code           => 765,
            time_zone            => 'America/Chicago',
        },
        maxmind => {
            queries_remaining => 42,
        },
        postal => {
            code       => '12345',
            confidence => 57,
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

    test_model_class(
        'GeoIP2::Model::Insights',
        \%raw,
        sub {
            my $model = shift;

            is(
                $model->location->average_income, 12345,
                'check average_income'
            );
            is(
                $model->location->estimated_population, 45678,
                'check estimated_population'
            );
        }
    );
}

{
    test_model_class_with_empty_record('GeoIP2::Model::Insights');
    test_model_class_with_unknown_keys('GeoIP2::Model::Insights');
}

done_testing();
