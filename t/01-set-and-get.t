#!perl -T

use strict;
use warnings;
use Test::Simple tests => 8;

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

ok( $ring->clear_password($USER, 'my@@domain') eq 0, "clear_password again has nothing to clear" );

ok( $ring->clear_password("Non user", 'my@@domain') eq 0, "clear_password for unknown user has nothing to clear" );
ok( $ring->clear_password("$USER", 'non domain') eq 0, "clear_password for unknown domain has nothing to clear" );
