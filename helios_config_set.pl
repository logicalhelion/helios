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
our $Value;
our $Help_Mode = 0;
our $Debug_Mode = 0;

our $Config;

GetOptions (
	"service=s"  => \$Service_Name,
	"param=s"    => \$Param_Name,
	"hostname=s" => \$Host,
	"value=s"    => \$Value,
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
unless ($Service_Name && $Param_Name && $Host && $Value) {
	warn "$0: A service name, config parameter name, and value are required.\n";
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

# OK, now use Helios::Config to attempt to set the 
# param in the collective database
eval {
	Helios::Config->setParam(
		service_name => $Service_Name,
		hostname     => $Host,
		param        => $Param_Name,
		value        => $Value,
	);
	1;	
} or do {
	my $E = $@;
	warn "$0: Helios::Config ERROR: $E\n";
	exit(1);
};

if ($Debug_Mode) {
	print "SERVICE: $Service_Name HOST: $Host PARAM: $Param_Name set to VALUE: $Value\n";
}

exit(0);

