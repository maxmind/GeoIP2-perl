use strict;
use warnings;

use Test::Fatal;
use Test::More 0.88;

use GeoIP2::Model::Country;

{
    my $model = GeoIP2::Model::Country->new(
        raw => {
            country => {
                geoname_id         => 1,
                iso_3166_1_alpha_2 => 'US',
                iso_3166_1_alpha_3 => 'USA',
                names              => { en => 'United States of America' },
            },
            traits  => {},
        },
    );

    isa_ok(
        $model,
        'GeoIP2::Model::Country',
        'minimal GeoIP2::Model::Country object'
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
        'country iso_3166_1_alpha_3 is USA'
    );

}

done_testing();
