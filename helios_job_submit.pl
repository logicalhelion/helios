#!/usr/bin/perl

use 5.008;
use strict;
use warnings;

use Helios::Job;
use Helios::Config;

our $VERSION = '2.71_4460';

# CHANGES:
# 2012-01-22: Minor changes to comments.
# [LH] 2013-08-04: Changed service instantiation to use new Helios::Config API.
# [LH] [2013-10-28]: Updated to use Helios::Config and new Helios::Job API.  
# Replaced all try {} with eval {}.  Added --verbose option to return jobid.
# [LH] [2013-11-01]: changed cmd line arg parsing so -v and -n work as well as
# --verbose and --no-validate

=head1 NAME

helios_job_submit.pl - Submit a job to the Helios job processing system from the cmd line

=head1 SYNOPSIS

 helios_job_submit.pl [--jobid] [--no-validate] I<jobclass> [I<jobargs>]

 helios_job_submit.pl MyService "<job>params><myarg1>myvalue1</myarg1></params></job>"

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
# BEGIN CODE Copyright (C) 2013 by Logical Helion, LLC.
# [LH] [2013-10-28]: Added --verbose option.
our $OPT_VERBOSE = 0;
our @OPTS = @ARGV;
foreach (@OPTS) {
	last if !/^-/;
# END CODE Copyright (C) 2013 by Logical Helion, LLC.
	if ( lc($_) eq '--no-validate' || lc($_) eq '-n') {
		shift @ARGV;
		$VALIDATE = 0;
	}
	if ( lc($_) eq '--verbose' || lc($_ eq '-v')) {
		shift @ARGV;
		$OPT_VERBOSE = 1;
	}	
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

=old
#[]
# instantiate the base worker class just to get the [global] INI params
# (we need to know where the Helios db is)
my $WORKER = new Helios::Service;
# BEGIN [LH] 2012-08-04: Changed old service init to use new Helios::Config API
$WORKER->prep();
my $config = $WORKER->getConfig();
# END [LH] 2013-08-04
=cut

# BEGIN CODE Copyright (C) 2013 by Logical Helion, LLC.
my $config = Helios::Config->parseConfig();
# END CODE Copyright (C) 2013 by Logical Helion, LLC.

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

=old
#[]
# create a Helios::Job object and submit it
my $hjob = Helios::Job->new();
$hjob->setConfig($config);
$hjob->setFuncname($JOB_CLASS);
$hjob->setArgXML($PARAMS);
my $jobid = $hjob->submit();
=cut

my $j = Helios::Job->new();
$j->setConfig($config);
$j->setJobType($JOB_CLASS);
$j->setArgString($PARAMS);
my $jobid = $j->submit();

if ($DEBUG_MODE) {
	print "Job submit successful.  JOBID: ",$jobid,"\n";
}

# BEGIN CODE Copyright (C) 2013 by Logical Helion, LLC.
if ($OPT_VERBOSE && !$DEBUG_MODE) {
	print "Jobid: $jobid\n";
}
# END CODE Copyright (C) 2013 by Logical Helion, LLC.


=head1 SUBROUTINES

=head2 validateParamsXML($xml)

Given a wodge of parameter XML (wrapped by <job><params></params></job> tags), 
validateParamsXML returns a true value if the XML is valid, and a false value 
if it isn't.

=cut

sub validateParamsXML {
	my $arg = shift;
=old
#[]
#	try {
#		my $arg = Helios::Job->parseArgXML($arg);
#		return 1;
#	} catch Helios::Error::InvalidArg with {
#		my $e = shift;
#		print STDERR "Invalid job arguments: $arg (",$e->text(),")\n";
#		return undef;
#	};
=cut
	
	# [LH] [2013-10-28]: Replaced all try {} with eval {}	
	my $valid = 0;
	eval {
		$arg = Helios::Job->parseArgXML($arg);
		$valid = 1;
		1;
	} or do {
		my $E = $@;
		warn("Invalid job arguments: $arg (", $E->text(),")\n");
	};

}


=head1 SEE ALSO

L<Helios>, L<Helios::Job>

=head1 AUTHOR

Andrew Johnson, E<lt>lajandy at cpan dotorgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008-9 by CEB Toolbox, Inc.

Portions of this software, where noted, are Copyright (C) 2013 by
Logical Helion, LLC.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=head1 WARRANTY

This software comes with no warranty of any kind.

=cut

