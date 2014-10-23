use strict;
use warnings;

use Test::More;
use Test::Fatal;

use GeoIP2::Database::Reader;
use Path::Class qw( file );

{
    my $reader = GeoIP2::Database::Reader->new(
        file => file(qw( maxmind-db test-data GeoIP2-Domain-Test.mmdb)) );

    my $ip_address = '1.2.0.0';
    my $record = $reader->domain( ip => $ip_address );
    is( $record->domain, 'maxmind.com', 'correct domain in Domain database' );
    is( $record->ip_address, $ip_address, 'correct IP in Domain database' );
}

done_testing();
