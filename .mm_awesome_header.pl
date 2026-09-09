use File::Spec::Functions qw(catdir); 

use Alien::Sodium ();
use Alien::Base::Wrapper ();
use Devel::CheckLib qw(check_lib);
use Getopt::Std;

my %opts;

getopt('D:', \%opts) or die usage();

my $include_deprecated = ( defined $opts{D} && $opts{D} eq 'yes' ) ? 1 : 0;

my $alien_include = '-I' . catdir(Alien::Sodium->dist_dir(), 'include');
my $alien_libs    = Alien::Sodium->libs();
my $alien_cflags = Alien::Sodium->cflags();

sub clean_ccflags {
    use Config;
    my $ccflags = $Config{ccflags};
    $ccflags =~ s:-I\S*::g;
    return $ccflags;
}

sub has_aes256gcm {
    use Mock::Config ccflags => clean_ccflags();
    my $ret = check_lib(
        debug => 0,
        function => 'return !(!sodium_init() && crypto_aead_aes256gcm_is_available());',
        LIBS => $alien_libs,
        ccflags => $alien_cflags,
        header => 'sodium.h',
    );
    Mock::Config->unimport;      # Undo overrides
    return $ret;
}

sub has_aes128ctr {
    use Mock::Config ccflags => clean_ccflags();
    my $ret = check_lib(
        debug => 0,
        function => 'sodium_init(); return crypto_stream_aes128ctr_NONCEBYTES ? 0 : 1;',
        LIBS => $alien_libs,
        ccflags => $alien_cflags,
        header => 'sodium.h',
    );
    Mock::Config->unimport;      # Undo overrides
    return $ret;
}

my @defines;
push @defines, 'AES256GCM_IS_AVAILABLE' if has_aes256gcm();
push @defines, 'AES128CTR_IS_AVAILABLE' if has_aes128ctr();
push @defines, 'INCLUDE_DEPRECATED' if $include_deprecated;
my %xsbuild = Alien::Base::Wrapper->new('Alien::Sodium')->mm_args2(
    "DEFINE" => join(" ", map { "-D$_" } @defines),
);

# use Data::Dumper;
# print Dumper(\%xsbuild);
# exit(1);
# Our cpanfile contains the proper configure requires already
delete $xsbuild{CONFIGURE_REQUIRES};
