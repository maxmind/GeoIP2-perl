use strict;
use warnings;

use Test::Fatal;
use Test::More 0.88;

use GeoIP2::Model::Country;

{
    my %raw = (
        continent => {
            continent_code => 'NA',
            geoname_id     => 42,
            names          => { en => 'North America' },
        },
        country => {
            geoname_id         => 1,
            iso_3166_1_alpha_2 => 'US',
            iso_3166_1_alpha_3 => 'USA',
            names              => { en => 'United States of America' },
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
        $model->traits(),
        'GeoIP2::Record::Traits',
        '$model->traits()'
    );

    is(
        $model->continent()->geoname_id(),
        42,
        'continent geoname_id is 42'
    );

    is(
        $model->continent()->continent_code(),
        'NA',
        'continent continent_code is NA'
    );

    is_deeply(
        $model->continent()->names(),
        { en => 'North America' },
        'continent names'
    );

    is(
        $model->continent()->name(),
        'North America',
        'continent name is North America'
    );

    is(
        $model->country()->geoname_id(),
        1,
        'country geoname_id is 1'
    );

    is(
        $model->country()->iso_3166_1_alpha_2(),
        'US',
        'country iso_3166_1_alpha_2 is US'
    );

    is(
        $model->country()->iso_3166_1_alpha_3(),
        'USA',
        'country iso_3166_1_alpha_3 is USA'
    );

    is_deeply(
        $model->country()->names(),
        { en => 'United States of America' },
        'country names'
    );

    is(
        $model->country()->name(),
        'United States of America',
        'country name is United States of America'
    );

    is(
        $model->country()->confidence(),
        undef,
        'country confidence is undef'
    );

    for my $meth (
        qw( is_anonymous_proxy is_transparent_proxy is_us_military )) {

        is(
            $model->traits()->$meth(),
            0,
            "traits $meth returns 0 by default"
        );
    }

    is_deeply(
        $model->raw(),
        \%raw,
        'raw method returns raw input'
    );
}

done_testing();
