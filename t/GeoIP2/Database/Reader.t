use strict;
use warnings;

use Test::More;
use Test::Fatal;

use GeoIP2::Database::Reader;
use Path::Class qw( file );

my @locales = qw( en de );

{
    for my $type ( qw( Country City Precision-City ) ) {

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

done_testing();
