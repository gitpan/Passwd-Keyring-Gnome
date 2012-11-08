use 5.006;
use strict;
use warnings;
use Module::Build;
use ExtUtils::PkgConfig;

my %gnome_keyring_pkg_info = ExtUtils::PkgConfig->find("gnome-keyring-1");

my $builder = Module::Build->new(
    module_name         => 'Passwd::Keyring::Gnome',
    dynamic_config      => 1,
    license             => 'perl',
    dist_author         => q{Marcin Kasperski <Marcin.Kasperski@mekk.waw.pl>},
    dist_version_from   => 'lib/Passwd/Keyring/Gnome.pm',
    build_requires => {
        'Module::Build' => '0.19', # xs
        'ExtUtils::CBuilder' => 0,
        'Test::More' => 0,
        'Test::Pod::Coverage' => '1.0.8',
    },
    requires => {
        'perl' => 5.006,
    },
    add_to_cleanup      => [ 'Passwd-Keyring-Gnome-*' ],
    create_makefile_pl => 'traditional',
    extra_compiler_flags => $gnome_keyring_pkg_info{cflags},
    extra_linker_flags => $gnome_keyring_pkg_info{libs},
    needs_compiler => 1,
    meta_merge => {
        keywords => [ qw/ passwords security secure-storage keyring GNOME seahorse gnome-keyring / ],
        resources => {
            license     => 'http://dev.perl.org/licenses/',
            homepage    => 'http://bitbucket.org/Mekk/perl-keyring-gnome',
            repository => 'http://bitbucket.org/Mekk/perl-keyring-gnome',
            bugtracker => 'https://bitbucket.org/Mekk/perl-keyring-gnome/issues',
        },
    },
);

$builder->create_build_script();
