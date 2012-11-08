#!perl -T

use strict;
use warnings;
use Test::Simple tests => 5;

use Passwd::Keyring::Gnome;

my $ring = Passwd::Keyring::Gnome->new;

ok( defined($ring) && ref $ring eq 'Passwd::Keyring::Gnome',   'new() works' );

my $USER = 'John';
my $PASSWORD = 'verysecret';

$ring->set_password($USER, $PASSWORD, 'my@@domain');

ok( 1, "set_password works" );

ok( $ring->get_password($USER, 'my@@domain') eq $PASSWORD, "get recovers");

ok( $ring->clear_password($USER, 'my@@domain') eq 1, "clear_password removed one password" );

ok( !defined($ring->get_password($USER, 'my@@domain')), "no password after clear");
