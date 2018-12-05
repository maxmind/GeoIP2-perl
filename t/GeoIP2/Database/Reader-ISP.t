use strict;
use warnings;

use Test::More;
use Test::Fatal;

use GeoIP2::Database::Reader;
use Path::Class qw( file );

{
    my $reader = GeoIP2::Database::Reader->new(
        file => file(qw( maxmind-db test-data GeoIP2-ISP-Test.mmdb )) );

    my $ip_address = '1.128.0.0';
    my $isp        = $reader->isp( ip => $ip_address );
    is(
        $isp->autonomous_system_number, 1221,
        'correct ASN in ISP database'
    );
    is(
        $isp->autonomous_system_organization,
        'Telstra Pty Ltd', 'correct AS Org in ISP database'
    );
    is( $isp->isp, 'Telstra Internet', 'correct ISP in ISP database' );
    is(
        $isp->organization, 'Telstra Internet',
        'correct Org in ISP database'
    );
    is( $isp->ip_address, $ip_address, 'correct IP in ISP database' );

}

done_testing();
