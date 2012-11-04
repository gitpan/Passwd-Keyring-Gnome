#!perl -T

use strict;
use warnings;
use Test::Simple tests => 5;

use Passwd::Keyring::Gnome;

my $ring = Passwd::Keyring::Gnome->new;

ok( defined($ring) && ref $ring eq 'Passwd::Keyring::Gnome',   'new() works' );

ok( ! defined($ring->get_password("Paul", 'my@@domain')), "get works");

ok( $ring->get_password("Gregory", 'my@@domain') eq 'secret-Greg', "get works");

ok( $ring->get_password("Paul", 'other@@domain') eq 'secret-Paul2', "get works");

ok( $ring->get_password("Duke", 'my@@domain') eq 'secret-Duke', "get works");


