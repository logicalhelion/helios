#!/usr/bin/perl

use strict;
use warnings;

use Error qw(:try);

use Helios::Job;
use Helios::Service;

our $VERSION = '2.50_3161';

=head1 NAME

helios_job_submit.pl - Submit a job to the Helios job processing system from the cmd line

=head1 SYNOPSIS

helios_job_submit.pl [--no-validate] I<jobclass> [I<jobargs>]

helios_job_submit.pl IndexService "<job>params><id>699</id></params></job>"

helios_job_submit.pl --help

=head1 DESCRIPTION

Use helios_job_submit.pl to submit a job to the Helios job processing system from the cmd line.  
The first parameter is the service class, and the second is the parameter XML that will be passed to 
the worker class for the job.  If the second parameter isn't given, the program will accept input 
from STDIN.

=cut

our $DEBUG_MODE = 0;
if (defined($ENV{HELIOS_DEBUG}) && $ENV{HELIOS_DEBUG} == 1) {
	$DEBUG_MODE = 1;
}

our $VALIDATE = 1;
if ( lc($ARGV[0]) eq '--no-validate') {
	shift @ARGV;
	$VALIDATE = 0;
}
our $JOB_CLASS = shift @ARGV;
our $PARAMS = shift @ARGV;

our $DATABASES_INFO;
our $VERBOSE = 0;

# print help if asked
if ( !defined($JOB_CLASS) || ($JOB_CLASS eq '--help') || ($JOB_CLASS eq '-h') ) {
	require Pod::Usage;
	Pod::Usage::pod2usage(-verbose => 2, -exitstatus => 0);
}

# instantiate the base worker class just to get the [global] INI params
# (we need to know where the Helios db is)
my $WORKER = new Helios::Service;
$WORKER->prep();
my $config = $WORKER->getConfig();

# if we were passed a <params> wodge of XML on the command line, 
# try to validate it
# if we DIDN'T get a <params> wodge, 
# then we have to assume it's coming from STDIN.  
# which probably means it's a metajob
if ( !defined($PARAMS) ) {
	# read them in from STDIN
	while (<>) {
		chomp;
		$PARAMS .= $_;
	}
}
# test the args before we submit
if ($VALIDATE) { validateParamsXML($PARAMS) or exit(1); }

# create a Helios::Job object and submit it
my $hjob = Helios::Job->new();
$hjob->setConfig($config);
$hjob->setFuncname($JOB_CLASS);
$hjob->setArgXML($PARAMS);
my $jobid = $hjob->submit();

if ($DEBUG_MODE) {
	print "Job submit successful.  JOBID: ",$jobid,"\n";
}


=head1 SUBROUTINES

=head2 validateParamsXML($xml)

Given a wodge of parameter XML (wrapped by <job><params></params></job> tags), 
validateParamsXML returns a true value if the XML is valid, and a false value 
if it isn't.

=cut

sub validateParamsXML {
	my $arg = shift;
	try {
		my $arg = Helios::Job->parseArgXML($arg);
		return 1;
	} catch Helios::Error::InvalidArg with {
		my $e = shift;
		print STDERR "Invalid job arguments: $arg (",$e->text(),")\n";
		return undef;
	};
}


=head1 SEE ALSO

L<Helios>, L<helios.pl>, L<Helios::Service>, L<Helios::Job>

=head1 AUTHOR

Andrew Johnson, E<lt>lajandy at cpan dotorgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008-9 by CEB Toolbox, Inc.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=head1 WARRANTY

This software comes with no warranty of any kind.

=cut

