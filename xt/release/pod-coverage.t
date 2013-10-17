#!/usr/bin/perl

use strict;
use warnings;

use Pod::Coverage::Moose 0.02;
use Test::More;
use Test::Pod::Coverage 1.04;

my %trustme = ();

# This is a stripped down version of all_pod_coverage_ok which lets us
# vary the trustme parameter per module.
my @modules = grep { !/^GeoIP2::(?:Role|Types)/ } all_modules();

for my $module ( sort @modules ) {
    my $trustme = [];

    if ( $trustme{$module} ) {
        my $methods = join '|', @{ $trustme{$module} };
        $trustme = [qr/^(?:$methods)$/];
    }

    pod_coverage_ok(
        $module,
        {
            coverage_class => 'Pod::Coverage::Moose',
            trustme        => $trustme,
        },
        "Pod coverage for $module"
    );
}

done_testing();
