use strict;
use warnings;

use Test::More 0.88;

use GeoIP2::Model::Country;

{
    my %raw = (
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
        maxmind => {
            queries_remaining => 42,
        },
        registered_country => {
            geoname_id           => 2,
            is_in_european_union => 1,
            iso_code             => 'DE',
            names                => { en => 'Germany' },
        },
        traits => {
            ip_address => '1.2.3.4',
        },
    );

    my $model = GeoIP2::Model::Country->new(%raw);

    isa_ok(
        $model,
        'GeoIP2::Model::Country',
        'minimal GeoIP2::Model::Country object'
    );

    isa_ok(
        $model->continent,
        'GeoIP2::Record::Continent',
        '$model->continent'
    );

    isa_ok(
        $model->country,
        'GeoIP2::Record::Country',
        '$model->country'
    );

    isa_ok(
        $model->maxmind,
        'GeoIP2::Record::MaxMind',
        '$model->maxmind'
    );

    isa_ok(
        $model->registered_country,
        'GeoIP2::Record::Country',
        '$model->registered_country'
    );

    isa_ok(
        $model->traits,
        'GeoIP2::Record::Traits',
        '$model->traits'
    );

    is(
        $model->continent->geoname_id,
        42,
        'continent geoname_id is 42'
    );

    is(
        $model->continent->code,
        'NA',
        'continent code is NA'
    );

    is_deeply(
        $model->continent->names,
        { en => 'North America' },
        'continent names'
    );

    is(
        $model->continent->name,
        'North America',
        'continent name is North America'
    );

    is(
        $model->country->geoname_id,
        1,
        'country geoname_id is 1'
    );

    is(
        $model->country->is_in_european_union,
        0,
        'country is_in_european_union is 0'
    );

    is(
        $model->country->iso_code,
        'US',
        'country iso_code is US'
    );

    is_deeply(
        $model->country->names,
        { en => 'United States of America' },
        'country names'
    );

    is(
        $model->country->name,
        'United States of America',
        'country name is United States of America'
    );

    is(
        $model->country->confidence,
        undef,
        'country confidence is undef'
    );

    is(
        $model->registered_country->geoname_id,
        2,
        'registered_country geoname_id is 2'
    );

    is(
        $model->registered_country->is_in_european_union,
        1,
        'registered_country is_in_european_union is 1'
    );

    is(
        $model->registered_country->iso_code,
        'DE',
        'registered_country iso_code is DE'
    );

    is_deeply(
        $model->registered_country->names,
        { en => 'Germany' },
        'registered_country names'
    );

    is(
        $model->registered_country->name,
        'Germany',
        'registered_country name is Germany'
    );

    for my $meth (qw( is_anonymous_proxy is_satellite_provider )) {
        is(
            $model->traits->$meth(),
            0,
            "traits $meth returns 0 by default"
        );
    }

    is_deeply(
        $model->raw,
        \%raw,
        'raw method returns raw input'
    );
}

done_testing();
