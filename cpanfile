on 'runtime' => sub {
    requires 'perl' => '5.008001';
    requires 'strict';
    requires 'warnings';
    requires 'Carp';
    requires 'Sub::Exporter';
    requires 'XSLoader';
};

on 'configure' => sub {
    requires 'Alien::Sodium' => '2.000';
    requires 'Alien::Base::Wrapper' => '2.15';
    requires 'Config';
    requires 'Devel::CheckLib';
    requires 'ExtUtils::MakeMaker' => '6.52';
};

on 'build' => sub {
    requires 'Alien::Sodium' => '2.000';
    requires 'Alien::Base::Wrapper' => '2.15';
    requires 'Config';
    requires 'ExtUtils::MakeMaker';
};

on 'test' => sub {
    requires 'strict';
    requires 'warnings';
    requires 'utf8';
    requires 'Config';
    requires 'Cwd';
    requires 'Devel::Peek';
    requires 'File::Basename';
    requires 'File::Spec';
    requires 'Test::More' => '0.88';
};

on 'develop' => sub {
    requires 'Dist::Zilla';
    requires 'Test::CheckManifest' => '1.29';
    requires 'Test::CPAN::Changes' => '0.4';
    requires 'Test::Kwalitee'      => '1.22';
    requires 'Test::Pod::Spelling::CommonMistakes' => '1.000';
};
