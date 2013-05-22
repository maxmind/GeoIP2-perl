use strict;
use warnings;

use Test::Spelling;

my @stopwords;
for (<DATA>) {
    chomp;
    push @stopwords, $_
        unless /\A (?: \# | \s* \z)/msx;    # skip comments, whitespace
}

add_stopwords(@stopwords);
set_spell_cmd('aspell list -l en');

# This prevents a weird segfault from the aspell command - see
# https://bugs.launchpad.net/ubuntu/+source/aspell/+bug/71322
local $ENV{LC_ALL} = 'C';
all_pod_files_spelling_ok;

__DATA__
API
APIs
AdWords
CN
GEONAMES
GeoIP
GeoNames
GitHub
IANA
IP
IP's
IPv
ISP
MaxMind
MaxMind's
OC
Omni
Oxfordshire
Rolsky
SSL
URI
VERSIONING
YY
YYZZ
ZZ
contentDeliveryNetwork
de
dialup
downloadable
ergument
geoname_id
hostname
ip
ja
lookup
maxmind
routable
ru
searchEngineSpider
ua
unpopulated
versioning
zh
