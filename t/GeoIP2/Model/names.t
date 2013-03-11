use strict;
use warnings;
use utf8;

use Test::Fatal;
use Test::More 0.88;

use GeoIP2::Model::Country;

{
    my $tb = Test::Builder->new();

    binmode $_, ':encoding(UTF-8)'
        for $tb->output(),
        $tb->failure_output(),
        $tb->todo_output();
}

my %raw = (
    continent => {
        continent_code => 'NA',
        geoname_id     => 42,
        names          => {
            en      => 'North America',
            'zh-CN' => '北美洲',
        },
    },
    country => {
        geoname_id         => 1,
        iso_3166_1_alpha_2 => 'US',
        iso_3166_1_alpha_3 => 'USA',
        names              => {
            en      => 'United States of America',
            fr      => 'États-Unis',
            'zh-CN' => '美国',
        },
    },
    traits => {
        ip_address => '1.2.3.4',
    },
);

{
    my $model = GeoIP2::Model::Country->new(
        %raw,
        languages => [ 'fr', 'zh-CN', 'en' ],
    );

    is(
        $model->continent()->name(),
        '北美洲',
        'continent name is in Chinese (no French available)'
    );

    is(
        $model->country()->name(),
        'États-Unis',
        'country name is in French'
    );
}

{
    my $model = GeoIP2::Model::Country->new(
        %raw,
        languages => [ 'fr', 'de' ],
    );

    is(
        $model->continent()->name(),
        undef,
        'continent name is undef (no French available)'
    );

    is(
        $model->country()->name(),
        'États-Unis',
        'country name is in French'
    );
}

{
    my $model = GeoIP2::Model::Country->new(
        %raw,
        languages => ['de'],
    );

    is(
        $model->continent()->name(),
        undef,
        'continent name is undef (no German available) '
    );

    is(
        $model->country()->name(),
        undef,
        'country name is undef (no German available) '
    );
}

done_testing();
