package Acme::Intraweb; 

=begin comment

28600 lines in CPANPLUS. Hard-coded to /usr/home/root - doesn't read user's conf
ig file and a config file or parameters from it can't be specified. Have to edit
 /usr/lib/perl5/site_perl/$perlversion/CPANPLUS/Config.pm.
Might be able to get CPANPLUS working with the PERL5_CPANPLUS_CONFIG environment variable.
Though a 'use lib "/home/person/.cpanplus/"' would make us use the correct per-use
config file...

XXX should let the user will do something like 'use lib' in their code and place
modules there - use a PREFIX of the first thing in @INC. Otherwise superuser
Perl installs will fail. Only when perl is installed by a user/group as is
running the Perl programs will this work.

=cut


$VERSION = 1.02;

use strict;
use warnings;

use CPAN;
use File::Spec; 

my $loaded;   # we try to add ourselves to @INC only once and that's on first use
my $tried;    # no second tries on installing a module

sub import {
    $loaded++ or push @INC, sub {

        my $fn = my $mod = $_[1];
        for($mod) { s./.::.g; s/.pm$//i; }

        if ( not $tried->{$mod}++ ) {

            # system qq{cpanp i "$mod"};
            # could dup and then close STDOUT and STDERR for silent option
            CPAN::Shell->install($mod);

            for(@INC) {
                next if ref;
                if(-e "$_/$fn" and -r _) {
                    open my $fh, "$_/$fn" or die $!;
                    return $fh;
                }
            }
        }

        return undef;

    }
}
1;

__END__

=pod

=head1 NAME

Acme::Intraweb

=head1 SYNOPSIS

    use Acme::Intraweb;

    use Some::Module::Not::Yet::Installed


=head1 DESCRIPTION

Acme::Intraweb allows you to use modules not yet installed on your
system. Rather than throw annoying errors about "Could not locate
package Foo::Bar in @INC", Acme::Intraweb will just go to your
closest CPAN mirror and try to install the module for you, so your
program can go on it's merry way.

=head1 USE

Make sure to mention C<use Acme::Intraweb> before any other module you
might not have, so it can have a chance to install it for you.

Everything else goes automatically.

=head1 BUGS

In code this funky, I'm sure there are some ;)

This fails to install modules unless the Perl programs are run as a
user who has permission to install modules.
It should pick the first thing off of C<@INC> (the last directory supplied
to C<use lib>) and attempt to install there instead of the system
directory.
I (Scott) need to figure out how to specify flags to F<Makefile.PL> to C<CPAN>.

=head1 NOTE

This program requires (a configured version of) CPAN to work.

=head1 AUTHOR

This module by
Jos Boumans E<lt>kane@cpan.orgE<gt>.


=head1 COPYRIGHT

This module is
copyright (c) 2002 Jos Boumans E<lt>kane@cpan.orgE<gt>.
All rights reserved.
Goop (c) 2005 added by Scott Walters E<lt>scott@slowass.netE<gt>.

This library is free software;
you may redistribute and/or modify it under the same
terms as Perl itself.

=cut
