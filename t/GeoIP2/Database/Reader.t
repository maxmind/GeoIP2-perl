use strict;
use warnings;

use Test::More;
use Test::Fatal;

use GeoIP2::Database::Reader;
use Path::Class qw( file );

my @locales = qw( en de );

{
    for my $type (qw( Country City Precision-City )) {

        my $reader = GeoIP2::Database::Reader->new(
            file =>
                file( 'maxmind-db', 'test-data', "GeoIP2-$type-Test.mmdb" )
                ->stringify,
            locales => \@locales
        );

        ( my $model = lc $type ) =~ s/^precision-//;

        like(
            exception { $reader->$model() },
            qr/Required param/,
            "dies on missing ip - $model method"
        );

        like(
            exception { $reader->$model( ip => 'me' ) },
            qr/me is not a valid IP/,
            qq{dies on "me" - $model method}
        );

        like(
            exception { $reader->$model( ip => '10.0.0.0' ) },
            qr/not a public IP/,
            qq{dies on private IP - $model method}
        );

        like(
            exception { $reader->$model( ip => '9.10.11.12' ) },
            qr/\QNo record found for IP address 9.10.11.12/,
            "dies if IP is not in database - $model method"
        );

        my $e = exception { $reader->$model( ip => '9.10.11.12' ) };
        isa_ok(
            $e,
            'GeoIP2::Error::IPAddressNotFound',
            'error thrown when IP address cannot be found'
        );

        is(
            $e->ip_address,
            '9.10.11.12',
            'exception ip_address() method returns the IP address'
        );

        like(
            exception { $reader->$model( ip => 'x' ) },
            qr/\QThe IP address you provided (x) is not a valid IPv4 or IPv6 address/,
            "dies on invalid ip - $model method"
        );

        my $ip = '81.2.69.160';
        my $model_obj = $reader->$model( ip => $ip );

        is(
            $model_obj->country->name,
            'United Kingdom',
            "country name - $model method"
        );

        is(
            $model_obj->traits->ip_address,
            '81.2.69.160',
            "ip address is filled in - $model method"
        );

        my @record_methods = qw(
            city
            continent
            country
            location
            maxmind
            postal
            registered_country
            represented_country
            traits
        );

        for my $method ( grep { $model_obj->can($_) } @record_methods ) {
            is(
                exception { $model_obj->$method() },
                undef,
                "calling \$model_obj->$method() does not throw an error - $model model"
            );
        }

        next if $model eq 'country';

        is( $model_obj->city->name, 'London', "city name - $model method" );
    }
}

{
    # We want to test the type checking in _model_for_address without having
    # to actually having test files for all the different database types.
    my $force_type;
    {
        no warnings 'redefine';
        *MaxMind::DB::Metadata::database_type = sub { $force_type };
    }

    my $reader
        = GeoIP2::Database::Reader->new(
        file => file( 'maxmind-db', 'test-data', "GeoIP2-City-Test.mmdb" )
            ->stringify );

    my @model_methods = qw(
        city
        country
        connection_type
        domain
        isp
        anonymous_ip
    );

    my %type_to_model = (
        'GeoIP2-City'                      => { city            => 1 },
        'GeoIP2-Precision-City'            => { city            => 1 },
        'GeoIP2-City-Europe'               => { city            => 1 },
        'GeoLite2-City'                    => { city            => 1 },
        'GeoIP2-Country'                   => { country         => 1 },
        'GeoIP2-Precision-Country'         => { country         => 1 },
        'GeoLite2-Country'                 => { country         => 1 },
        'GeoIP2-Connection-Type'           => { connection_type => 1 },
        'GeoIP2-Precision-Connection-Type' => { connection_type => 1 },
        'GeoIP2-Domain'                    => { domain          => 1 },
        'GeoIP2-Precision-Domain'          => { domain          => 1 },
        'GeoIP2-ISP'                       => { isp             => 1 },
        'GeoIP2-Precision-ISP'             => { isp             => 1 },
        'GeoIP2-Anonymous-IP'              => { anonymous_ip    => 1 },
        'GeoIP2-Precision-Anonymous-IP'    => { anonymous_ip    => 1 },
    );

    for my $type ( sort keys %type_to_model ) {
        $force_type = $type;

        for my $method (@model_methods) {
            if ( $type_to_model{$type}{$method} ) {
                like(
                    exception { $reader->$method( ip => '9.10.11.12' ) },
                    qr/\QNo record found for IP address 9.10.11.12/,
                    "the $method method accepts $type database"
                );
            }
            else {
                like(
                    exception { $reader->$method( ip => '9.10.11.12' ) },
                    qr/\QThe GeoIP2::Database::Reader->$method() method cannot be called with a $type database/,
                    "the $method method rejected $type database"
                );
            }
        }
    }
}

done_testing();
