#!perl -T

use strict;
use warnings;
use Test::Simple tests => 2;

use Passwd::Keyring::Gnome;

my $ring = Passwd::Keyring::Gnome->new;

ok( defined($ring) && ref $ring eq 'Passwd::Keyring::Gnome',   'new() works' );

ok( $ring->is_persistent eq 1, "is_persistent knows we are persistent");

