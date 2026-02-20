# Dist::Zilla::Plugin::MakeMaker::Awesome 0.49.
# Don't edit it but the dist.ini and plugins used to construct it.

use strict;
use warnings;

use ExtUtils::MakeMaker;

use File::Spec::Functions qw(catdir); 

use Alien::Sodium ();
use Alien::Base::Wrapper ();
use Devel::CheckLib qw(check_lib);

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
my %xsbuild = Alien::Base::Wrapper->new('Alien::Sodium')->mm_args2(
    "DEFINE" => join(" ", map { "-D$_" } @defines),
);

# use Data::Dumper;
# print Dumper(\%xsbuild);
# exit(1);
# Our cpanfile contains the proper configure requires already
delete $xsbuild{CONFIGURE_REQUIRES};

my %WriteMakefileArgs = (
  "ABSTRACT" => "NaCl compatible modern, easy-to-use library for encryption, decryption, signatures, password hashing and more",
  "AUTHOR" => "Alex J. G. Burzy\x{144}ski <ajgb\@cpan.org>",
  "BUILD_REQUIRES" => {
    "Alien::Base::Wrapper" => "2.15",
    "Alien::Sodium" => "2.000",
    "Config" => 0,
    "ExtUtils::MakeMaker" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "Alien::Base::Wrapper" => "2.15",
    "Alien::Sodium" => "2.000",
    "Config" => 0,
    "Devel::CheckLib" => 0,
    "ExtUtils::MakeMaker" => "6.52"
  },
  "DISTNAME" => "Crypt-NaCl-Sodium",
  "LICENSE" => "perl",
  "NAME" => "Crypt::NaCl::Sodium",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Sub::Exporter" => 0,
    "XSLoader" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "Config" => 0,
    "Cwd" => 0,
    "Devel::Peek" => 0,
    "ExtUtils::MakeMaker" => 0,
    "File::Basename" => 0,
    "File::Spec" => 0,
    "Test::More" => "0.88",
    "strict" => 0,
    "utf8" => 0,
    "warnings" => 0
  },
  "VERSION" => "2.002",
  "test" => {
    "TESTS" => "t/*.t"
  }
);

%WriteMakefileArgs = (
    %WriteMakefileArgs,
    %xsbuild,
);

my %FallbackPrereqs = (
  "Alien::Base::Wrapper" => "2.15",
  "Alien::Sodium" => "2.000",
  "Carp" => 0,
  "Config" => 0,
  "Cwd" => 0,
  "Devel::Peek" => 0,
  "ExtUtils::MakeMaker" => 0,
  "File::Basename" => 0,
  "File::Spec" => 0,
  "Sub::Exporter" => 0,
  "Test::More" => "0.88",
  "XSLoader" => 0,
  "strict" => 0,
  "utf8" => 0,
  "warnings" => 0
);

unless ( eval { ExtUtils::MakeMaker->VERSION('6.63_03') } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
