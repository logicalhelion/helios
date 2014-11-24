package Helios::Error::JobTypeError;

use 5.008008;
use strict;
use warnings;
use parent 'Helios::Error::BaseError';

our $VERSION = '2.90_0000';

1;
__END__


=head1 NAME

Helios::Error::JobTypeError - exception class for Helios indicating a  
jobtype error occurred

=head1 SYNOPSIS

 use Helios::Error::JobTypeError;
 Helios::Error::JobTypeError->throw("A JobType error!");

=head1 DESCRIPTION

When the Helios::JobType class encounters a problem, it will throw a 
JobTypeError exception. 

=head1 AUTHOR

Andrew Johnson, E<lt>lajandy at cpan dotorgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Logical Helion, LLC.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=head1 WARRANTY

This software comes with no warranty of any kind.

=cut
