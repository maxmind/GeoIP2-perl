use strict;
use warnings;

use Test::More;
use Test::Fatal;

use GeoIP2::Database::Reader;
use Path::Class qw( file );

{    # Anonymous IP
    my $reader
        = GeoIP2::Database::Reader->new(
        file => file(qw( maxmind-db test-data GeoIP2-Anonymous-IP-Test.mmdb))
        );

    my %tests = (
        '1.2.0.0' => {
            is_anonymous        => 1,
            is_anonymous_vpn    => 1,
            is_hosting_provider => 0,
            is_public_proxy     => 0,
            is_tor_exit_node    => 0,
        },
        '6.7.8.9' => {
            is_anonymous        => 0,
            is_anonymous_vpn    => 0,
            is_hosting_provider => 0,
            is_public_proxy     => 0,
            is_tor_exit_node    => 0,
        },
        '71.160.223.45' => {
            is_anonymous        => 1,
            is_anonymous_vpn    => 0,
            is_hosting_provider => 1,
            is_public_proxy     => 0,
            is_tor_exit_node    => 0,
        },
        '186.30.236.233' => {
            is_anonymous        => 1,
            is_anonymous_vpn    => 0,
            is_hosting_provider => 0,
            is_public_proxy     => 1,
            is_tor_exit_node    => 0,
        },
        '65.4.3.2' => {
            is_anonymous        => 1,
            is_anonymous_vpn    => 0,
            is_hosting_provider => 0,
            is_public_proxy     => 0,
            is_tor_exit_node    => 1,
        },
        'abcd:1000::1' => {
            is_anonymous        => 1,
            is_anonymous_vpn    => 0,
            is_hosting_provider => 0,
            is_public_proxy     => 1,
            is_tor_exit_node    => 0,
        },
    );

    for my $ip ( sort keys %tests ) {
        my $model = $reader->anonymous_ip( ip => $ip );
        for my $meth ( sort keys %{ $tests{$ip} } ) {
            if ( $tests{$ip}{$meth} ) {
                ok(
                    $model->$meth(),
                    "$meth is true for $ip"
                );
            }
            else {
                ok(
                    !$model->$meth(),
                    "$meth is false for $ip"
                );
            }
        }
    }
}

done_testing();
