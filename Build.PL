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
    # pkg-config --cflags gnome-keyring-1
    #extra_compiler_flags => '-I/usr/include/gnome-keyring-1 -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include',
    extra_compiler_flags => $gnome_keyring_pkg_info{cflags},
    # pkg-config --libs gnome-keyring-1
    #extra_linker_flags => '-lgnome-keyring -lglib-2.0',
    extra_linker_flags => $gnome_keyring_pkg_info{libs},
    needs_compiler => 1,
    #c_source => 'src',
    #xs_files => {
        #'./Costam.xs' => 'lib/MyMod/Costam.xs',
    #},
);

$builder->create_build_script();
