
use strict;
use warnings;

use Cwd            ();
use File::Basename ();
use File::Spec     ();
use Crypt::NaCl::Sodium qw(:utils);
use Test::More;

sub add_l {
    my $S = shift;
    my $l = "\x{ed}\x{d3}\x{f5}\x{5c}\x{1a}\x{63}\x{12}\x{58}\x{d6}\x{9c}\x{f7}\x{a2}\x{de}\x{f9}\x{de}\x{14}\x{00}\x{00}\x{00}\x{00}\x{00}\x{00}\x{00}\x{00}\x{00}\x{00}\x{00}\x{00}\x{00}\x{00}\x{00}\x{10}";

    # equivalent of sodium_add($S, $l, length($l))
    return Crypt::NaCl::Sodium::add($S, $l);
}

sub getTestData {
    my $dir  = File::Basename::dirname(Cwd::abs_path __FILE__);
    my $file = File::Spec->catfile($dir, 'sodium_sign.dat');
    open(my $fh, '<', $file) or die "Cannot open test data file: $!";
    my @tests;
    while (my $line = <$fh>) {
        my ($sk, $pk, $sig, $msg)
            = $line =~ /\[\[([^\]]+)\]\[([^\]]+)\]\[([^\]]+)\]"([^"]*)"\]/;

        push @tests, {sk => hex2bin($sk), pk => hex2bin($pk), sig => hex2bin($sig), msg => hex2bin($msg),};
    }

    return @tests;
}

my $crypto_sign = Crypt::NaCl::Sodium->sign();
my $keypair_seed = "\x{42}\x{11}\x{51}\x{a4}\x{59}\x{fa}\x{ea}\x{de}\x{3d}\x{24}\x{71}\x{15}\x{f9}\x{4a}\x{ed}\x{ae}\x{42}\x{31}\x{81}\x{24}\x{09}\x{5a}\x{fa}\x{be}\x{4d}\x{14}\x{51}\x{a5}\x{59}\x{fa}\x{ed}\x{ee}";

diag(Crypt::NaCl::Sodium::sodium_version_string());
ok($crypto_sign->$_ > 0, "$_ > 0")
    for qw( BYTES PUBLICKEYBYTES SECRETKEYBYTES SEEDBYTES );

my @tests = getTestData();

my ($mac, $pk, $msg);    # last test used later
my $i = 0;
foreach my $test (@tests) {
    $i++;

    $pk = $test->{pk};
    $msg = $test->{msg};
    my $skpk    = substr($test->{sk}, 0, $crypto_sign->SEEDBYTES)
        . substr($test->{pk}, 0, $crypto_sign->PUBLICKEYBYTES);

    my $sealed = $crypto_sign->seal($msg, $skpk);
    ok($sealed, "message $i sealed");
    my $s_sealed = "$sealed";

    is(substr($s_sealed, 0, $crypto_sign->BYTES),
        $test->{sig}, "signature $i correct");

    my $opened = $crypto_sign->open($sealed, $test->{pk});
    is($opened, $test->{msg}, "message $i opened");

    my $mod_sealed = substr($s_sealed, 0, 32) . add_l(substr($s_sealed, 32));
    isnt($sealed, $mod_sealed, "modified $i sealed message");

    my $error;
    my $mod_opened;
    {
        # In libsodium versions <= 1.08.0 this test would return no error
        # as malleable signatures were allowed.  You need to build
        # libsodium with #define ED25519_COMPAT to retain the malleable
        # signatures
        local $@;
        #<<<  do not let perltidy touch this
        $error = $@ || 'Error' unless eval {
            $mod_opened = $crypto_sign->open($mod_sealed, $test->{pk});
            1;
        };
        #>>>
    }
    if ($mod_opened && bin2hex($mod_opened) eq $test->{msg}) {
        ok(1, "message $i is malleable");
    }
    else {
        ok(1, "Message $i is not malleable");
        next;
    }

    my $c = ord(substr($mod_sealed, ($i-1) + $crypto_sign->BYTES - 1, 1));
    $c = ($c + 1) & 0xFF;
    substr($mod_sealed, ($i-1) + $crypto_sign->BYTES - 1, 1, chr($c));

    eval { my $mod_opened = $crypto_sign->open($mod_sealed, $test->{pk}); };
    like($@, qr/Message forged/, "message $i was forged");

    $mac = $crypto_sign->mac($msg, $skpk);
    ok($mac, "detached signature $i");
    ok(length($mac) != 0 && length($mac) <= $crypto_sign->BYTES,
        "...and $i of correct length");
    is($mac, $test->{sig}, "correct signature $i");

    ok($crypto_sign->verify($mac, $msg, $pk), "...and verified $i");
}

if ($mac) {
    my $s_mac = "$mac";    # from byteslocker
    foreach my $j (1 .. 7) {
        my $c = ord(substr($s_mac, 63, 1));
        $c ^= ($j << 5);
        substr($s_mac, 63, 1, chr($c & 0xFF));

        ok(
            !$crypto_sign->verify($s_mac, $msg, $pk),
            "detached signature verification $j failed"
        );

        $c ^= ($j << 5);
        substr($s_mac, 63, 1, chr($c & 0xFF));
    }

    ok(
        !$crypto_sign->verify(
            $s_mac, $msg, "\0" x $crypto_sign->PUBLICKEYBYTES
        ),
        "detached signature verification have failed"
    );
}

my ($pkey, $skey) = $crypto_sign->keypair();
ok($pkey, "pkey generated");
ok($skey, "skey generated");

($pkey, $skey) = $crypto_sign->keypair($keypair_seed);
ok($pkey, "pkey generated from seed");
ok($skey, "skey generated from seed");

my $extract_seed = $crypto_sign->extract_seed($skey);
ok($extract_seed, "extracted seed from generated secret key");
is(bin2hex($extract_seed), bin2hex($keypair_seed), "...and is correct");

my $extract_pkey = $crypto_sign->public_key($skey);
ok($extract_pkey, "extracted pkey from generated secret key");
is(bin2hex($extract_pkey), bin2hex($pkey), "...and is correct");

is(bin2hex($pkey),
    "b5076a8474a832daee4dd5b4040983b6623b5f344aca57d4d6ee4baf3f259e6e",
    "correct pkey");
is(
    bin2hex($skey),
    "421151a459faeade3d247115f94aedae42318124095afabe4d1451a559faedeeb5076a8474a832daee4dd5b4040983b6623b5f344aca57d4d6ee4baf3f259e6e",
    "correct skey"
);
done_testing();
