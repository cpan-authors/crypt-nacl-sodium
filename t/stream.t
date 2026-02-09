
use strict;
use warnings;
use Test::More;


use Crypt::NaCl::Sodium qw(bin2hex);

my $sodium = Crypt::NaCl::Sodium->new();
my $crypto_stream = Crypt::NaCl::Sodium->stream();

my ($major, $minor, $patch) = split '\.', Crypt::NaCl::Sodium::sodium_version_string();
print "$major.$minor.$patch\n";
my @bytes = qw( NONCEBYTES KEYBYTES CHACHA20_NONCEBYTES CHACHA20_KEYBYTES
                SALSA20_NONCEBYTES SALSA20_KEYBYTES );
push @bytes, 'AES128CTR_NONCEBYTES' if $patch le 14;
push @bytes, 'AES128CTR_KEYBYTES' if $patch le 14; 
ok($crypto_stream->$_ > 0, "$_ > 0")
    for ( @bytes );

my %tests = (
    'XSalsa20' => {
        method_prefix => '',
        const_prefix => '',
        has_xor_ic => 1,
    },
    'ChaCha20' => {
        method_prefix => 'chacha20_',
        const_prefix => 'CHACHA20_',
        has_xor_ic => 1,
    },
    'Salsa20' => {
        method_prefix => 'salsa20_',
        const_prefix => 'SALSA20_',
        has_xor_ic => 1,
    },
    'AES-128-CTR' => {
        method_prefix => 'aes128ctr_',
        const_prefix => 'AES128CTR_',
    },
);

my $msg = chr(0x42) x 160;

for my $c ( sort keys %tests ) {
    next if $c eq 'AES-128-CTR' and $patch gt 14; 
    my $method_prefix = $tests{$c}->{method_prefix};
    my $const_prefix = $tests{$c}->{const_prefix};

    my $keygen_method =  $method_prefix . 'keygen';
    my $key_length = $const_prefix . 'KEYBYTES';

    my $nonce_method = $method_prefix . 'nonce';
    my $nonce_length = $const_prefix . 'NONCEBYTES';

    my $bytes_method = $method_prefix . 'bytes';
    my $xor_method = $method_prefix . 'xor';
    my $xoric_method = $method_prefix . 'xor_ic';

    my $key = $crypto_stream->$keygen_method();
    ok($key, "${c}->${keygen_method}");
    is(length($key), $crypto_stream->$key_length(), "...with correct length");

    my $nonce = $crypto_stream->$nonce_method();
    ok($nonce, "${c}->${nonce_method}");
    is(length($nonce), $crypto_stream->$nonce_length(), "...with correct length");

    my $bytes = $crypto_stream->$bytes_method( 32, $nonce, $key );
    ok($bytes, "${c}->${bytes_method}");
    is(length($bytes), 32, "...with correct length");

    my $encrypted = $crypto_stream->$xor_method( $msg, $nonce, $key );
    ok($encrypted, "${c}->${xor_method} (encrypt)");
    is(length($encrypted), length($msg), "...with length of the message");

    if ( $tests{$c}->{has_xor_ic} ) {
        my $ic = 1;
        my $encrypted_1 = $crypto_stream->$xoric_method( $msg, $nonce, $ic, $key );
        ok($encrypted_1, "${c}->${xoric_method} (encrypt)");
        is(length($encrypted_1), length($msg), "...with length of the message");
        my $block_1 = substr(bin2hex($encrypted), 128);
        like(bin2hex($encrypted_1), qr/^$block_1/, "...and is next block");

        my $decrypted_1 = $crypto_stream->$xoric_method( $encrypted_1, $nonce, $ic, $key );
        ok($decrypted_1, "${c}->${xoric_method} (decrypt)");
        is(length($decrypted_1), length($msg), "...with length of the message");
        is($decrypted_1, $msg, "...and matches the message");
    }


    my $decrypted = $crypto_stream->$xor_method( $encrypted, $nonce, $key );
    ok($decrypted, "${c}->${xor_method} (decrypt)");
    is(length($decrypted), length($msg), "...with length of the message");
    is($decrypted, $msg, "...and matches the message");
}

done_testing();
