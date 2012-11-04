#!perl -T

use strict;
use warnings;
use Test::Simple tests => 8;

use Passwd::Keyring::Gnome;

my $ring = Passwd::Keyring::Gnome->new;

ok( defined($ring) && ref $ring eq 'Passwd::Keyring::Gnome',   'new() works' );

$ring->clear_password("Paul", 'my@@domain');
ok(1, "clear_password works");

ok( $ring->clear_password("Gregory", 'my@@domain'));
ok(1, "clear_password works");

ok( $ring->clear_password("Paul", 'other@@domain'));
ok(1, "clear_password works");

ok( $ring->clear_password("Duke", 'my@@domain'));
ok(1, "clear_password works");


