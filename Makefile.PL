
use strict;
use warnings;

use 5.010000;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Perl API for MaxMind's GeoIP Precision web services and GeoIP2 databases",
  "AUTHOR" => "Dave Rolsky <autarch\@urth.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "GeoIP2",
  "EXE_FILES" => [
    "bin/webservice-request"
  ],
  "LICENSE" => "artistic_2",
  "NAME" => "GeoIP2",
  "PREREQ_PM" => {
    "Data::Dumper" => 0,
    "Data::Validate::IP" => 0,
    "Exporter" => 0,
    "Getopt::Long" => 0,
    "JSON" => 0,
    "LWP::Protocol::https" => 0,
    "LWP::UserAgent" => 0,
    "List::MoreUtils" => 0,
    "List::Util" => 0,
    "MIME::Base64" => 0,
    "Moo" => 0,
    "Moo::Role" => 0,
    "Params::Validate" => 0,
    "Scalar::Util" => 0,
    "Sub::Quote" => 0,
    "Throwable::Error" => 0,
    "Try::Tiny" => 0,
    "URI" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "B" => 0,
    "HTTP::Status" => 0,
    "Test::Fatal" => 0,
    "Test::LWP::UserAgent" => 0,
    "Test::More" => "0.88",
    "utf8" => 0
  },
  "VERSION" => "0.01",
  "test" => {
    "TESTS" => "t/*.t t/GeoIP2/*.t t/GeoIP2/Model/*.t t/GeoIP2/Webservice/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);

1;
