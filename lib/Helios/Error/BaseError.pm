package Helios::Error::BaseError;

use 5.008008;
use strict;
use warnings;
use parent 'Exception::Class::Base';

our $VERSION = '2.90_0000';

sub text { $_[0]->error() }

1;
__END__

=head1 NAME

Helios::Error::BaseError - base exception class for Helios services

=head1 SYNOPSIS

 use Helios::Error::BaseError;
 -OR-
 use Helios::Error;    # automatically loads and imports this and other exceptions

=head1 DESCRIPTION

Helios::Error::BaseError is the base class for all the exception classes in 
the Helios::Error hierarchy.

You can distinguish between Helios errors and other exceptions attempting to 
catch Helios::Error::BaseError rather than each specific class in the 
Helios::Error hierarchy.

Previously in Helios 2.x, Helios exceptions were based on Error::Simple from 
the L<Error> distribution.  In Helios 3.x, Helios::Error::BaseError (and all 
exceptions based on it) are based on Exception::Class::Base from the 
L<Exception::Class> distribution.  

#[] add the text() method?


=head1 SEE ALSO

L<Helios::Error>, L<Error>, L<Error::Simple>

=head1 AUTHOR

Andrew Johnson, E<lt>lajandy at cpan dot orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Logical Helion, LLC.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=head1 WARRANTY

This software comes with no warranty of any kind.

=cut


