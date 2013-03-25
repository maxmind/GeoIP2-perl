package GeoIP2::Error::Generic;

use strict;
use warnings;

use GeoIP2::Types qw( Str );

use Moo;

extends 'Throwable::Error';

1;

# ABSTRACT: A generic exception

__END__

=head1 SYNOPSIS

  use v5.10;

  use GeoIP2::Webservice::Client;
  use Scalar::Util qw( blessed );

  my $client = GeoIP2::Webservice::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  try {
      $client->omni( ip => '24.24.24.24' );
  }
  catch {
      die $_ unless blessed $_;
      die $_ if $_->isa('GeoIP2::Error::Generic');

      # handle other exceptions
  };

=head1 DESCRIPTION

This class represents a generic error. It extends L<Throwable::Error> and does
not add any additional attributes.

=head1 METHODS

This class has two methods, C<< $error->message() >>, and C<<
$error->stack_trace() >>. Both methods are inherited from L<Throwable::Error>.

