package Test::GeoIP2;

use strict;
use warnings;

use Test::Fatal;
use Test::More 0.88;

use Exporter qw( import );

our @EXPORT_OK = qw(
    test_model_class
    test_model_class_with_empty_record
    test_model_class_with_unknown_keys
);

sub test_model_class {
    my $class = shift;
    my $raw   = shift;

    my $model = $class->new($raw);

    isa_ok(
        $model,
        $class,
        "$class->new returns"
    );

    _shared_model_tests( $model, $class, $raw );

    my @subdivisions = $model->subdivisions();
    for my $i ( 0 .. $#subdivisions ) {
        isa_ok(
            $subdivisions[$i],
            'GeoIP2::Record::Subdivision',
            "\$model->subdivisions()[$i]"
        );
    }
}

sub test_model_class_with_empty_record {
    my $class = shift;

    my %raw = (
        maxmind => { queries_remaining => 42 },
        traits  => { ip_address        => '5.6.7.8' },
    );

    my $model = $class->new(%raw);

    isa_ok(
        $model,
        $class,
        "$class object with no data except maxmind.queries_remaining & traits.ip_address"
    );

    _shared_model_tests( $model, $class, \%raw );

    my @subdivisions = $model->subdivisions();
    is(
        scalar $model->subdivisions(),
        0,
        '$model->subdivisions returns an empty list'
    );
}

sub _shared_model_tests {
    my $model = shift;
    my $class = shift;
    my $raw   = shift;

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
        $model->maxmind(),
        'GeoIP2::Record::MaxMind',
        '$model->maxmind()'
    );

    isa_ok(
        $model->postal(),
        'GeoIP2::Record::Postal',
        '$model->postal()'
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
        $raw,
        'raw method returns raw input'
    );
}

sub test_model_class_with_unknown_keys {
    my $class = shift;

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
        exception { $model = $class->new(%raw) },
        undef,
        "no exception when $class class gets raw data with unknown keys"
    );

    is_deeply(
        $model->raw(),
        \%raw,
        'raw method returns raw input'
    );
}

1;
