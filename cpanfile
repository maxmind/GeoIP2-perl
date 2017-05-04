requires "B" => "0";
requires "Data::Dumper" => "0";
requires "Data::Validate::IP" => "0.24";
requires "Exporter" => "0";
requires "Getopt::Long" => "0";
requires "HTTP::Headers" => "0";
requires "HTTP::Request" => "0";
requires "JSON::MaybeXS" => "0";
requires "LWP::Protocol::https" => "0";
requires "LWP::UserAgent" => "0";
requires "List::MoreUtils" => "0";
requires "List::Util" => "0";
requires "MIME::Base64" => "0";
requires "MaxMind::DB::Reader" => "1.000000";
requires "Moo" => "0";
requires "Moo::Role" => "0";
requires "Params::Validate" => "0";
requires "Scalar::Util" => "0";
requires "Sub::Quote" => "0";
requires "Throwable::Error" => "0";
requires "Try::Tiny" => "0";
requires "URI" => "0";
requires "lib" => "0";
requires "namespace::clean" => "0";
requires "perl" => "5.008";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Spec" => "0";
  requires "HTTP::Response" => "0";
  requires "HTTP::Status" => "0";
  requires "IO::Compress::Gzip" => "0";
  requires "MaxMind::DB::Metadata" => "0";
  requires "Path::Class" => "0";
  requires "Test::Builder" => "0";
  requires "Test::Fatal" => "0";
  requires "Test::More" => "0.96";
  requires "Test::Number::Delta" => "0";
  requires "base" => "0";
  requires "utf8" => "0";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "Code::TidyAll::Plugin::SortLines::Naturally" => "0";
  requires "Code::TidyAll::Plugin::Test::Vars" => "0.02";
  requires "Code::TidyAll::Plugin::UniqueLines" => "0";
  requires "File::Spec" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Parallel::ForkManager" => "1.19";
  requires "Perl::Critic" => "1.126";
  requires "Perl::Tidy" => "20160302";
  requires "Pod::Coverage::Moose" => "0";
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Pod::Wordlist" => "0";
  requires "Test::CPAN::Changes" => "0.19";
  requires "Test::CPAN::Meta::JSON" => "0.16";
  requires "Test::CleanNamespaces" => "0.15";
  requires "Test::Code::TidyAll" => "0.50";
  requires "Test::EOL" => "0";
  requires "Test::Mojibake" => "0";
  requires "Test::More" => "0.96";
  requires "Test::NoTabs" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Portability::Files" => "0";
  requires "Test::Spelling" => "0.12";
  requires "Test::Synopsis" => "0";
  requires "Test::Vars" => "0.009";
  requires "Test::Version" => "2.05";
  requires "blib" => "1.01";
  requires "parent" => "0";
};
