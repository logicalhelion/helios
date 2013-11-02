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

our $VERSION = '2.71_43500000';

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
	warn "$0: a service name and config parameter name are required.\n";
	exit(1);
}

# parse the global config; we'll need it
eval {
	$Config = Helios::Config->parseConfig(service => $Service_Name);
	1;	
} or do {
	my $E = $@;
	warn "$0: Helios::Config ERROR: $E\n";
	exit(1);
};

# OK, now use Helios::Config to attempt to find the 
# param in the collective database
eval {
	$Value = Helios::Config->getParam(
		service_name  => $Service_Name,
		hostname      => $Host,
		param         => $Param_Name
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
	print STDOUT "$Value\n";
}

exit(0);


=head1 NAME

helios_config_get.pl - get a config parameter's value from the Helios collective database

=head1 SYNOPSIS

 helios_config_get.pl --service=<service name> [--hostname=<hostname>] --param=<param name>

 # get the value of the "endpoint_url" param for MyService on the current host
 helios_config_get.pl --service=MyService --param=endpoint_url

=head1 DESCRIPTION

The helios_config_get.pl command can be used to retrieve configuration 
parameters for a service from the Helios collective database.  This allows 
Helios configuration parameters to be accessed via shell scripts.

=head1 AUTHOR

Andrew Johnson, E<lt>lajandy at cpan dot orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Logical Helion, LLC.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=head1 WARRANTY

This software comes with no warranty of any kind.

=cut
