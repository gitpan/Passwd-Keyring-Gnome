package Passwd::Keyring::Gnome;

use warnings;
use strict;
#use parent 'Keyring';

require DynaLoader;
#require AutoLoader;

use base 'DynaLoader';

=head1 NAME

Passwd::Keyring::Gnome - Password storage implementation based on GNOME Keyring.

=head1 VERSION

Version 0.25

=cut

our $VERSION = '0.25';

bootstrap Passwd::Keyring::Gnome $VERSION;

=head1 SYNOPSIS

Gnome Keyring based implementation of L<Keyring>.

    use Passwd::Keyring::Gnome;

    my $keyring = Passwd::Keyring::Gnome->new(
         app=>"My beautiful app",     # in fact unimportant at the moment
         group=>"My app passwords",   # visible in seahorse and used to separate different passwords
    );

    $keyring->set_password("John", "verysecret", "my-pseudodomain");
    # And later, on next run maybe
    my $password = $keyring->get_password("John", "my-pseudodomain");
    # plus
    $keyring->clear_password("John", "my-pseudodomain");

Note: see L<Passwd::Keyring::KeyringAPI> for detailed comments on
keyring method semantics (this document is installed with
Passwd::Keyring::Auto package).

=head1 SUBROUTINES/METHODS

=head2 new(app=>'app name', group=>'passwords folder')

Initializes the processing. Croaks if gnome keyring does not 
seem to be available.

Handled named parameters: 

- app - symbolic app name (not used at the moment, but can be used in future as comment and in prompts, so set sensibly)

- group - name for password group (will be visible in seahorse so can be used to find passwords, different group means different password set)

=cut

sub new {
    my ($cls, %opts) = @_;
    my $self = {
        app => $opts{app} || 'Passwd::Keyring',
        group => $opts{group} || 'Passwd::Keyring unclassified passwords',
    };
    bless $self;

    # TODO: catch and rethrow exceptions
    my $name = Passwd::Keyring::Gnome::_get_default_keyring_name();
    croak ("Gnome Keyring seems unavailable") unless $name;

    return $self;
}

=head2 set_password(username, password, domain)

Sets (stores) password identified by given domain for given user 

=cut

sub set_password {
    my ($self, $user_name, $user_password, $domain) = @_;
    Passwd::Keyring::Gnome::_set_password($user_name, $user_password, $domain,
                                          $self->{app}, $self->{group});
}

=head2 get_password($user_name, $domain)

Reads previously stored password for given user in given app.
If such password can not be found, returns undef.

=cut

sub get_password {
    my ($self, $user_name, $domain) = @_;
    my $pwd = Passwd::Keyring::Gnome::_get_password($user_name, $domain,
                                                    $self->{app}, $self->{group});
    #return undef if (!defined($pwd)) or $pwd eq "";
    return $pwd;
}

=head2 clear_password($user_name, $domain)

Removes given password (if present)

Returns how many passwords actually were removed 

=cut

sub clear_password {
    my ($self, $user_name, $domain) = @_;
    return Passwd::Keyring::Gnome::_clear_password(
        $user_name, $domain, $self->{app}, $self->{group});
}

=head2 is_persistent

Returns info, whether this keyring actually saves passwords persistently.

(true in this case)

=cut

sub is_persistent {
    my ($self) = @_;
    return 1;
}


=head1 AUTHOR

Marcin Kasperski, C<< <Marcin.Kasperski at mekk.waw.pl> >>

=head1 BUGS

Please report any bugs or feature requests to 
issue tracker at L<https://bitbucket.org/Mekk/perl-keyring-gnome>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Passwd::Keyring::Gnome

You can also look for information at:

    L<https://bitbucket.org/Mekk/perl-keyring-gnome>

=head1 LICENSE AND COPYRIGHT

Copyright 2010-2012 Marcin Kasperski.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut


1; # End of Passwd::Keyring::Gnome

