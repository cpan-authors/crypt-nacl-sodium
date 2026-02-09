# NAME

Crypt::NaCl::Sodium - NaCl compatible modern, easy-to-use library for encryption, decryption, signatures, password hashing and more

# SYNOPSIS

```perl
use Crypt::NaCl::Sodium qw( :utils );

my $crypto = Crypt::NaCl::Sodium->new();

##########################
## Secret-key cryptography

# Secret-key authenticated encryption (XSalsa20/Poly1305 MAC)
my $crypto_secretbox = $crypto->secretbox();

# Secret-key message authentication (HMAC-SHA256, HMAC-SHA512, HMAC-SHA512/256 )
my $crypto_auth = $crypto->auth();

# Authenticated Encryption with Additional Data (ChaCha20/Poly1305 MAC, AES256-GCM)
my $crypto_aead = $crypto->aead();

##########################
## Public-key cryptography

# Public-key authenticated encryption (Curve25519/XSalsa20/Poly1305 MAC)
my $crypto_box = $crypto->box();

# Public-key signatures (Ed25519)
my $crypto_sign = $crypto->sign();

##########################
## Hashing

# Generic hashing (Blake2b)
my $crypto_generichash = $crypto->generichash();

# Short-input hashing (SipHash-2-4)
my $crypto_shorthash = $crypto->shorthash();

##########################
## Password hashing (yescrypt)

my $crypto_pwhash = $crypto->pwhash();

##########################
## Advanced

# SHA-2 (SHA-256, SHA-512)
my $crypto_hash = $crypto->hash();

# One-time authentication (Poly1305)
my $crypto_onetimeauth = $crypto->onetimeauth();

# Diffie-Hellman (Curve25519)
my $crypto_scalarmult = $crypto->scalarmult();

# Stream ciphers (XSalsa20, ChaCha20, Salsa20, AES-128-CTR)
my $crypto_stream = $crypto->stream();

##########################
## Utilities

# convert binary data to hexadecimal
my $hex = bin2hex($bin);

# convert hexadecimal to binary
my $bin = hex2bin($hex);

# constant time comparision of strings
memcmp($a, $b, $length ) or die '$a ne $b';

# constant time comparision of large numbers
compare($x, $y, $length ) == -1 and print '$x < $y';

# overwrite with null bytes
memzero($a, $b, ...);

# generate random number
my $num = random_number($upper_bound);

# generate random bytes
my $bytes = random_bytes($count);

##########################
## Guarded data storage

my $locker = Data::BytesLocker->new($password);
...
$locker->unlock();
print $locker->to_hex();
$locker->lock();
```

# DESCRIPTION

[Crypt::NaCl::Sodium](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium) provides bindings to libsodium - NaCl compatible modern,
easy-to-use library for  encryption, decryption, signatures, password hashing
and more.

It is a portable, cross-compilable, installable, packageable fork
of [NaCl](http://nacl.cr.yp.to/), with a compatible API, and an extended API to
improve usability even further.

Its goal is to provide all of the core operations needed to build
higher-level cryptographic tools.

The design choices emphasize security, and "magic constants" have
clear rationales.

And despite the emphasis on high security, primitives are faster
across-the-board than most implementations of the NIST
standards.

[Crypt::NaCl::Sodium](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium) uses [Alien::Sodium](https://metacpan.org/pod/Alien%3A%3ASodium) that tracks the most current
releases of libsodium.

# METHODS

## new

```perl
my $crypto = Crypt::NaCl::Sodium->new();
```

Returns a proxy object for methods provided below.

## secretbox

```perl
# Secret-key authenticated encryption (XSalsa20/Poly1305 MAC)
my $crypto_secretbox = Crypt::NaCl::Sodium->secretbox();
```

Read [Crypt::NaCl::Sodium::secretbox](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Asecretbox) for more details.

## auth

```perl
# Secret-key authentication (HMAC-SHA512/256 and advanced usage of HMAC-SHA-2)
my $crypto_auth = Crypt::NaCl::Sodium->auth();
```

Read [Crypt::NaCl::Sodium::auth](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Aauth) for more details.

## aead

```perl
# Authenticated Encryption with Additional Data (ChaCha20/Poly1305 MAC, AES256-GCM)
my $crypto_aead = Crypt::NaCl::Sodium->aead();
```

Read [Crypt::NaCl::Sodium::aead](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Aaead) for more details.

## box

```perl
# Public-key authenticated encryption (Curve25519/XSalsa20/Poly1305 MAC)
my $crypto_box = Crypt::NaCl::Sodium->box();
```

Read [Crypt::NaCl::Sodium::box](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Abox) for more details.

## sign

```perl
# Public-key signatures (Ed25519)
my $crypto_sign = Crypt::NaCl::Sodium->sign();
```

Read [Crypt::NaCl::Sodium::sign](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Asign) for more details.

## generichash

```perl
# Generic hashing (Blake2b)
my $crypto_generichash = Crypt::NaCl::Sodium->generichash();
```

Read [Crypt::NaCl::Sodium::generichash](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Agenerichash) for more details.

## shorthash

```perl
# Short-input hashing (SipHash-2-4)
my $crypto_shorthash = Crypt::NaCl::Sodium->shorthash();
```

Read [Crypt::NaCl::Sodium::shorthash](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Ashorthash) for more details.

## pwhash

```perl
# Password hashing (yescrypt)
my $crypto_pwhash = Crypt::NaCl::Sodium->pwhash();
```

Read [Crypt::NaCl::Sodium::pwhash](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Apwhash) for more details.

## hash

```perl
# SHA-2 (SHA-256, SHA-512)
my $crypto_hash = Crypt::NaCl::Sodium->hash();
```

Read [Crypt::NaCl::Sodium::hash](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Ahash) for more details.

## onetimeauth

```perl
# One-time authentication (Poly1305)
my $crypto_onetimeauth = Crypt::NaCl::Sodium->onetimeauth();
```

Read [Crypt::NaCl::Sodium::onetimeauth](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Aonetimeauth) for more details.

## scalarmult

```perl
# Diffie-Hellman (Curve25519)
my $crypto_scalarmult = Crypt::NaCl::Sodium->scalarmult();
```

Read [Crypt::NaCl::Sodium::scalarmult](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Ascalarmult) for more details.

## stream

```perl
# Stream ciphers (XSalsa20, ChaCha20, Salsa20, AES-128-CTR)
my $crypto_stream = Crypt::NaCl::Sodium->stream();
```

Read [Crypt::NaCl::Sodium::stream](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Astream) for more details.

# FUNCTIONS

```perl
use Crypt::NaCl::Sodium qw(:utils);
```

Imports all provided functions.

## bin2hex

```perl
my $hex = bin2hex($bin);
```

Returns converted `$bin` into a hexadecimal string.

## hex2bin

```perl
my $hex = "41 : 42 : 43";
my $bin = hex2bin($hex, ignore => ": ", max_len => 2 );
print $bin; # AB
```

Parses a hexadecimal string `$hex` and converts it to a byte sequence.

Optional arguments:

- ignore

    A string of characters to skip. For example, the string `": "` allows columns
    and spaces to be present at any locations in the hexadecimal string. These
    characters will just be ignored.

    If unset any non-hexadecimal characters are disallowed.

- max\_len

    The maximum number of bytes to return.

The parser stops when a non-hexadecimal, non-ignored character is
found or when `max_len` bytes have been written.

## memcmp

```
memcmp($a, $b, $length ) or die "\$a ne \$b for length: $length";
```

Compares strings in constant-time. Returns true if they match, false otherwise.

The argument `$length` is optional if variables are of the same length. Otherwise it is
required and cannot be greater then the length of the shorter of compared variables.

**NOTE:** ["memcmp" in Data::BytesLocker](https://metacpan.org/pod/Data%3A%3ABytesLocker#memcmp) provides the same functionality.

```
$locker->memcmp($b, $length) or die "\$locker ne \$b for length: $length";
```

## compare

```
compare($x, $y, $length ) == -1 and print '$x < $y';
```

A constant-time version of ["memcmp"](#memcmp), useful to compare nonces and counters
in little-endian format, that plays well with ["increment"](#increment).

Returns `-1` if `$x` is lower then `$y`, `0` if `$x` and `$y` are
identical, or `1` if `$x` is greater then `$y`. Both `$x` and `$y` are
assumed to be numbers encoded in little-endian format.

The argument `$length` is optional if variables are of the same length. Otherwise it is
required and cannot be greater then the length of the shorter of compared variables.

**NOTE:** ["compare" in Data::BytesLocker](https://metacpan.org/pod/Data%3A%3ABytesLocker#compare) provides the same functionality.

```
$locker->compare($y, $length) == -1 and print "\$locker < \$y for length: $length";
```

## memzero

```
memzero($a, $b, ...);
```

Replaces the value of the provided stringified variables with `null` bytes. Length of the
zeroed variables is unchanged.

## random\_number

```perl
my $num = random_number($upper_bound);
```

Returns an unpredictable number between 0 and optional `$upper_bound`
(excluded).
If `$upper_bound` is not specified the maximum value is `0xffffffff`
(included).

## increment

```
increment($nonce, ...);
```

**NOTE:** This function is deprecated and will be removed in next version. Please
use ["increment" in Data::BytesLocker](https://metacpan.org/pod/Data%3A%3ABytesLocker#increment).

Increments an arbitrary long unsigned number(s) (in place). Function runs in constant-time
for a given length of arguments and considers them to be encoded in
little-endian format.

## random\_bytes

```perl
my $bytes = random_bytes($num_of_bytes);
```

Generates unpredictable sequence of `$num_of_bytes` bytes.

The length of the `$bytes` equals the value of `$num_of_bytes`.

Returns [Data::BytesLocker](https://metacpan.org/pod/Data%3A%3ABytesLocker) object.

## add

```perl
# equivalent of sodium_add($S, $l, length($l))
my $x = Crypt::NaCl::Sodium::add($S, $l);
```

Accepts two integers.  It computes (a + b) mod 2^(8\*len) in constant time
for a given length and returns the result.

Returns Integer

## has\_aes128ctr

```perl
my $supported = Crypt::NaCl::Sodium::has_aes128ctr()
```

Checks whether the underlying libsodium supports ASE128CTR

Returns &PL\_sv\_yes or &PL\_sx\_no

## sodium\_version\_string

```perl
my $version = Crypt::NaCl::Sodium::sodium_version_string()
```

Gets the libsodium version string

Returns a string like "1.0.18"

# VARIABLES

## $Data::BytesLocker::DEFAULT\_LOCKED

```perl
use Crypt::NaCl::Sodium;
$Data::BytesLocker::DEFAULT_LOCKED = 1;
```

By default all values returned from the provided methods are
unlocked [Data::BytesLocker](https://metacpan.org/pod/Data%3A%3ABytesLocker) objects. If this variable is set to true then
the returned objects are locked and require calling
["unlock" in Data::BytesLocker](https://metacpan.org/pod/Data%3A%3ABytesLocker#unlock) before accessing.

# SEE ALSO

- [Crypt::NaCl::Sodium::secretbox](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Asecretbox) - Secret-key authenticated encryption (XSalsa20/Poly1305 MAC)
- [Crypt::NaCl::Sodium::auth](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Aauth) - Secret-key message authentication (HMAC-SHA256, HMAC-SHA512, HMAC-SHA512/256 )
- [Crypt::NaCl::Sodium::aead](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Aaead) - Authenticated Encryption with Additional Data (ChaCha20/Poly1305 MAC, AES256-GCM)
- [Crypt::NaCl::Sodium::box](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Abox) - Public-key authenticated encryption (Curve25519/XSalsa20/Poly1305 MAC)
- [Crypt::NaCl::Sodium::sign](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Asign) - Public-key signatures (Ed25519)
- [Crypt::NaCl::Sodium::generichash](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Agenerichash) - Generic hashing (Blake2b)
- [Crypt::NaCl::Sodium::shorthash](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Ashorthash) - Short-input hashing (SipHash-2-4)
- [Crypt::NaCl::Sodium::pwhash](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Apwhash) - Password hashing (yescrypt)
- [Crypt::NaCl::Sodium::hash](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Ahash) - SHA-2 (SHA-256, SHA-512)
- [Crypt::NaCl::Sodium::onetimeauth](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Aonetimeauth) - One-time authentication (Poly1305)
- [Crypt::NaCl::Sodium::scalarmult](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Ascalarmult) - Diffie-Hellman (Curve25519)
- [Crypt::NaCl::Sodium::stream](https://metacpan.org/pod/Crypt%3A%3ANaCl%3A%3ASodium%3A%3Astream) - Stream ciphers (XSalsa20, ChaCha20, Salsa20, AES-128-CTR)
- [Data::BytesLocker](https://metacpan.org/pod/Data%3A%3ABytesLocker) - guarded data storage
- [libsodium](http://jedisct1.gitbooks.io/libsodium) - libsodium

# AUTHOR

Alex J. G. Burzyński <`ajgb@cpan.org`>

# COPYRIGHT & LICENSE

Copyright (c) 2015 Alex J. G. Burzyński. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
