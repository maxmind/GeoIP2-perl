use strict;
use warnings;

use Test::Fatal;
use Test::More 0.88;

use B ();
use GeoIP2::Types qw( :all );
use JSON;
use LWP::UserAgent;
use Scalar::Util qw( blessed looks_like_number );
use URI;

my $ZERO    = 0;
my $ONE     = 1;
my $INT     = 100;
my $NEG_INT = -100;
my $NUM     = 42.42;
my $NEG_NUM = -42.42;

my $EMPTY_STRING = q{};
my $STRING       = 'foo';
my $IPV4         = '1.2.3.4';
my $IPV6         = '1234:fb29::421a';

my $ARRAY_REF = [];
my $HASH_REF  = {};

my $OBJECT = bless {}, 'Foo';

my $UNDEF = undef;

{
    package Thing;

    sub foo { }
}

my $CLASS_NAME = 'Thing';

my %tests = (
    Bool => {
        accept => [
            $UNDEF,
            $EMPTY_STRING,
            $ZERO,
            $ONE,
        ],
        reject => [
            $STRING,
            $INT,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
            $ARRAY_REF,
            $HASH_REF,
            $OBJECT,
        ],
    },
    HTTPStatus => {
        accept => [
            200,
            201,
            300,
            301,
            400,
            410,
            500,
            501,
        ],
        reject => [
            $UNDEF,
            $EMPTY_STRING,
            $STRING,
            $ZERO,
            $ONE,
            $INT,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
            $ARRAY_REF,
            $HASH_REF,
            $OBJECT,
        ],
    },
    HashRef => {
        accept => [
            $HASH_REF,
        ],
        reject => [
            $UNDEF,
            $EMPTY_STRING,
            $STRING,
            $ZERO,
            $ONE,
            $INT,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
            $ARRAY_REF,
            $OBJECT,
        ],
    },
    IPAddress => {
        accept => [
            $IPV4,
            $IPV6,
        ],
        reject => [
            $UNDEF,
            $EMPTY_STRING,
            $STRING,
            $ZERO,
            $ONE,
            $INT,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
            $ARRAY_REF,
            $OBJECT,
        ],
    },
    JSONObject => {
        accept => [
            JSON->new(),
        ],
        reject => [
            $UNDEF,
            $EMPTY_STRING,
            $STRING,
            $ZERO,
            $ONE,
            $INT,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
            $ARRAY_REF,
            $OBJECT,
        ],
    },
    LanguagesArrayRef => {
        accept => [
            [],
            [ 'en', 'ru' ],
            [ 'zh-CN', 'ja', 'en' ],
        ],
        reject => [
            $UNDEF,
            $EMPTY_STRING,
            $STRING,
            $ZERO,
            $ONE,
            $INT,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
            [ 'foo', 'bar' ],
            $OBJECT,
        ],
    },
    MaxMindID => {
        accept => [
            $ONE,
            $INT,
        ],
        reject => [
            $UNDEF,
            $EMPTY_STRING,
            $STRING,
            $ZERO,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
            $ARRAY_REF,
            $OBJECT,
        ],
    },
    MaxMindLicenseKey => {
        accept => [
            ( 'a' x 12 ),
            ( 'A' x 12 ),
            ( '1' x 12 ),
            '123456abcABC'
        ],
        reject => [
            $UNDEF,
            $EMPTY_STRING,
            $STRING,
            $ZERO,
            $ONE,
            $INT,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
            $ARRAY_REF,
            $OBJECT,
        ],
    },
    MaybeStr => {
        accept => [
            $UNDEF,
            $EMPTY_STRING,
            $STRING,
            $ZERO,
            $ONE,
            $INT,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
        ],
        reject => [
            $ARRAY_REF,
            $HASH_REF,
            $OBJECT,
        ],
    },
    NameHashRef => {
        accept => [
            {},
            { en => 'foo' },
            {
                en => 'foo',
                fr => 'le foo',
            },
        ],
        reject => [
            $UNDEF,
            $EMPTY_STRING,
            $STRING,
            $ZERO,
            $ONE,
            $INT,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
            $ARRAY_REF,
            { en => [] },
            $OBJECT,
        ],
    },
    NonNegativeInt => {
        accept => [
            $ZERO,
            $ONE,
            $INT,
        ],
        reject => [
            $UNDEF,
            $EMPTY_STRING,
            $STRING,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
            $ARRAY_REF,
            $HASH_REF,
            $OBJECT,
        ],
    },
    Num => {
        accept => [
            $ZERO,
            $ONE,
            $INT,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
        ],
        reject => [
            $UNDEF,
            $EMPTY_STRING,
            $STRING,
            $ARRAY_REF,
            $HASH_REF,
            $OBJECT,
        ],
    },
    PositiveInt => {
        accept => [
            $ONE,
            $INT,
        ],
        reject => [
            $UNDEF,
            $EMPTY_STRING,
            $STRING,
            $ZERO,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
            $ARRAY_REF,
            $HASH_REF,
            $OBJECT,
        ],
    },
    Str => {
        accept => [
            $EMPTY_STRING,
            $STRING,
            $ZERO,
            $ONE,
            $INT,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
        ],
        reject => [
            $UNDEF,
            $ARRAY_REF,
            $HASH_REF,
            $OBJECT,
        ],
    },
    URIObject => {
        accept => [
            URI->new('http://example.com'),
        ],
        reject => [
            $UNDEF,
            $EMPTY_STRING,
            $STRING,
            $ZERO,
            $ONE,
            $INT,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
            $ARRAY_REF,
            $HASH_REF,
            $OBJECT,
        ],
    },
    UserAgentObject => {
        accept => [ LWP::UserAgent->new() ],
        reject => [
            $UNDEF,
            $EMPTY_STRING,
            $STRING,
            $ZERO,
            $ONE,
            $INT,
            $NEG_INT,
            $NUM,
            $NEG_NUM,
            $ARRAY_REF,
            $HASH_REF,
            $OBJECT,
        ],
    },
);

for my $type ( sort keys %tests ) {
    my $type_constant = __PACKAGE__->can($type)
        or die "No such type: $type";
    my $type_sub = $type_constant->();

    for my $accept ( @{ $tests{$type}{accept} } ) {
        is(
            exception { $type_sub->($accept) },
            undef,
            "$type accepts " . _describe($accept)
        );
    }

    for my $reject ( @{ $tests{$type}{reject} } ) {
        like(
            exception { $type_sub->($reject) },
            qr/is not a valid/,
            "$type rejects " . _describe($reject)
        );
    }
}

sub _describe {
    my $val = shift;

    return 'undef' unless defined $val;

    if ( !ref $val ) {
        return q{''} if $val eq q{};

        $val =~ s/\n/\\n/g;

        return looks_like_number($val) ? $val : B::perlstring($val);
    }

    if ( blessed $val ) {
        my $desc = ( ref $val ) . ' object';

        return $desc;
    }
    else {
        return ( ref $val ) . ' reference';
    }
}

done_testing();
