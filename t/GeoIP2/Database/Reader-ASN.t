use strict;
use warnings;

use Test::More;
use Test::Fatal;

use GeoIP2::Database::Reader ();
use Path::Class qw( file );

my $reader = GeoIP2::Database::Reader->new(
    file => file(qw( maxmind-db test-data GeoLite2-ASN-Test.mmdb )) );

my $ip_address = '1.128.0.0';
my $asn        = $reader->asn( ip => $ip_address );
is(
    $asn->autonomous_system_number, 1221,
    'correct ASN in ASN database'
);
is(
    $asn->autonomous_system_organization,
    'Telstra Pty Ltd', 'correct AS Org in ASN database'
);
is( $asn->ip_address, $ip_address, 'correct IP in ASN database' );

done_testing();
