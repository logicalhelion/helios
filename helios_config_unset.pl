#!/usr/bin/env perl

use 5.008;
use strict;
use warnings;
use Getopt::Long;
use Sys::Hostname;
use File::Basename;

use Helios::Config;
use Helios::Error;
use Helios::LogEntry::Levels ':all';

our $VERSION = '2.71_4250';

our $Service_Name;
our $Param_Name;
our $Host = hostname();
our $Help_Mode = 0;
our $Debug_Mode = 0;

our $Config;
our $Value;

GetOptions (
	"service=s"  => \$Service_Name,
	"param=s"    => \$Param_Name,
	"hostname=s" => \$Host,
	"help"       => \$Help_Mode,
	"debug"      => \$Debug_Mode
);

# debug mode
if ($Debug_Mode) { Helios::Config->debug(1); }

# help mode
if ($Help_Mode) {
	require Pod::Usage;
	Pod::Usage::pod2usage(-verbose => 2, -exitstatus => 0);
}

# stop if we were not given at least service and param
unless ($Service_Name && $Param_Name) {
	warn "$0: A service name and config parameter name are required.\n";
	exit(1);
}

# parse the global config; we'll need it
eval {
	$Config = Helios::Config->parseConfig();
	1;	
} or do {
	my $E = $@;
	warn "$0: Helios::Config ERROR: $E\n";
	exit(1);
};

# OK, now use Helios::Config to attempt to find the 
# param in the collective database
eval {
	$Value = Helios::Config->unsetParam(
		service_name => $Service_Name,
		hostname     => $Host,
		param        => $Param_Name
	);
	1;	
} or do {
	my $E = $@;
	warn "$0: Helios::Config ERROR: $E\n";
	exit(1);
};

# if we found the param, print its value
# if not, we print nothing
if ( defined($Value) ) {
	print STDOUT "SERVICE: $Service_Name HOST: $Host PARAM: $Param_Name CLEARED.\n";
}

exit(0);

