#!perl -T

use strict;
use warnings;
#use Test::More tests => 11;
use Test::More skip_all => "Currently app and group are meaningful. To be decided whether to keep this behaviour";

use Passwd::Keyring::Gnome;

my $USER = "Herakliusz";
my $DOMAIN = "test domain";
my $PWD = "arcytajne haslo";

my $orig_ring = Passwd::Keyring::Gnome->new(app=>"Passwd::Keyring::Unit tests", group=>"Yet so");

ok( defined($orig_ring) && ref $orig_ring eq 'Passwd::Keyring::Gnome',   'new() works' );

ok( ! defined($orig_ring->get_password($USER, $DOMAIN)), "initially unset");

$orig_ring->set_password($USER, $PWD, $DOMAIN);
ok(1, "set password");

ok( $orig_ring->get_password($USER, $DOMAIN) eq $PWD, "normal get works");


# Another object with the same app/group

my $ring = Passwd::Keyring::Gnome->new(app=>"Passwd::Keyring::Unit tests", group=>"Yet so");

ok( defined($ring) && ref $ring eq 'Passwd::Keyring::Gnome', 'second new() works' );

ok( $ring->get_password($USER, $DOMAIN) eq $PWD, "get from another ring with the same data works");

# Only group changes

$ring = Passwd::Keyring::Gnome->new(app=>"Passwd::Keyring::Unit tests", group=>"It has changed");

ok( defined($ring) && ref $ring eq 'Passwd::Keyring::Gnome', 'third new() works' );

ok( $ring->get_password($USER, $DOMAIN) eq $PWD, "get from another ring with different group works");

# App and group change

$ring = Passwd::Keyring::Gnome->new(app=>"Something else", group=>"Yet Yet so");

ok( defined($ring) && ref $ring eq 'Passwd::Keyring::Gnome', 'fourth new() works' );

ok( $ring->get_password($USER, $DOMAIN) eq $PWD, "get from another ring with changed app and group works");


# Cleanup
ok( $orig_ring->clear_password($USER, $DOMAIN) eq 1, "clearing");

