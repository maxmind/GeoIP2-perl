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
GeoLite
GeoNames
GitHub
IANA
IP
IP's
IPv
ISP
Knop
MaxMind
MaxMind's
OC
Omni
Oschwald
Oxfordshire
Rolsky
SSL
URI
VERSIONING
YYY
YYYZZZ
contentDeliveryNetwork
de
dialup
downloadable
ergument
geoname_id
hostname
ip
ja
libmaxminddb
lookup
maxmind
omni
params
routable
ru
searchEngineSpider
ua
unpopulated
versioning
zh
