package GeoIP2::Error::Type;

use strict;
use warnings;

use GeoIP2::Types qw( Str );

use Moo;

extends 'Throwable::Error';

1;

# ABSTRACT: A type validation error.

__END__

=head1 SYNOPSIS

  use 5.008;

  use GeoIP2::WebService::Client;
  use Scalar::Util qw( blessed );
  use Try::Tiny;

  my $client = GeoIP2::WebService::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  try {
      $client->omni( ip => '24.24.24.24' );
  }
  catch {
      die $_ unless blessed $_;
      if ( $_->isa('GeoIP2::Error::Type') ) {
          log_validation_error(
              name   => $_->name(),
              value  => $_->value(),
          );
      }

      # handle other exceptions
  };

=head1 DESCRIPTION

This class represents a Moo type validation error. It extends
L<Throwable::Error> and adds attributes of its own.

=head1 METHODS

The C<< $error->message() >>, and C<< $error->stack_trace() >> methods are
inherited from L<Throwable::Error>. It also provide two methods of its own:

=head2 $error->name()

Returns the name of the type which failed validation.

=head2 $error->value()

Returns the value which triggered the validation failure.

