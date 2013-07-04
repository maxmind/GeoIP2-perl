use strict;
use warnings;

use Test::More;

use GeoIP2::DatabaseReader;

my $file = 't/test-data/GeoIP2-Precision-City.mmdb';

my $languages = [ 'en', 'de', ];

my $reader
    = GeoIP2::DatabaseReader->new( file => $file, languages => $languages );

ok( $reader, 'got reader' );

my $ip   = '81.2.69.160';
my $omni = $reader->omni( $ip );

is( $omni->city->name, 'London', 'city name' );

done_testing();
