use Alien::Sodium ();
use Alien::Base::Wrapper ();
use Devel::CheckLib qw(check_lib);

sub has_aes256gcm {
    return check_lib(
        debug => 0,
        function => 'return !(!sodium_init() && crypto_aead_aes256gcm_is_available());',
        LIBS => Alien::Sodium->libs,
        ccflags => Alien::Sodium->cflags(),
        header => 'sodium.h',
    );
}

sub has_aes128ctr {
    return check_lib(
        debug => 0,
        function => 'sodium_init(); return crypto_stream_aes128ctr_NONCEBYTES ? 0 : 1;',
        LIBS => Alien::Sodium->libs,
        ccflags => Alien::Sodium->cflags(),
        header => 'sodium.h',
    );
}

my @defines;
push @defines, 'AES256GCM_IS_AVAILABLE' if has_aes256gcm();
push @defines, 'AES128CTR_IS_AVAILABLE' if has_aes128ctr();
my %xsbuild = Alien::Base::Wrapper->new('Alien::Sodium')->mm_args2(
    "DEFINE" => join(" ", map { "-D$_" } @defines),
);
# use Data::Dumper;
# print Dumper(\%xsbuild);
# exit(1);
# Our cpanfile contains the proper configure requires already
delete $xsbuild{CONFIGURE_REQUIRES};
