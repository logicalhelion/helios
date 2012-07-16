package Helios;

use 5.008000;

our $VERSION = '2.50_2860';


=head1 NAME

Helios - a distributed job processing system

=head1 DESCRIPTION

Helios is a system for building asynchronous distributed job processing 
applications.  Applications that need to process millions of small units of 
work in parallel can use the Helios system to scale this work across the 
multiple processes and servers that form a Helios collective.  Helios may also 
be used to improve the user experience on websites.  By utilizing the 
framework's APIs, potential timeout issues can be eliminated and response times 
decreased for larger tasks invoked in response to user input.  The web server 
application can "fire and forget" in the background, immediately returning 
control to the user.  Using Helios, simple Perl applications can be written 
to distribute massive workloads throughout the Helios collective while 
still retaining centralized management.

The Helios module itself is merely a placeholder for versioning and 
documentation purposes.  If you want to require Helios (or a certain version 
of it) in your package, adding 

 Helios => 2.00

to the PREREQ_PM hashref in Makefile.PL should do the trick.

=head1 SEE ALSO

L<helios.pl>, L<Helios::Service>, L<Helios::Error>

=head1 AUTHOR

Andrew Johnson, E<lt>lajandy at cpan dotorgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008-9 by CEB Toolbox, Inc.

Portions of this software are Copyright (C) 2009-12 by Andrew Johnson where noted.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=head1 WARRANTY

This software comes with no warranty of any kind.

=cut

