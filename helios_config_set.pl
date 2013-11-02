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
unless ($Service_Name && $Param_Name && $Host && defined($Value)) {
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


=head1 NAME

helios_config_set.pl - set a config param's value in the Helios database

=head1 SYNOPSIS

 helios_config_set.pl --service=<service name> --param=<param name> --value=<param value>
   [--hostname=<hostname>]
   
 # set the "endpoint_url" param for MyService on all hosts
 helios_config_set.pl --service=MyService --hostname=* --param=endpoint_url \
   --value=http://webserver/app.pl
   
 # set the "port" param for MyService on the current host
 helios_config_set.pl --service=MyService --param=port --value=8080

=head1 DESCRIPTION

The helios_config_set.pl command can be used to set configuration 
parameters for a service in the Helios collective database.  This allows 
Helios configuration parameters to be created or changed from the command line 
or shell scripts. 

If the --hostname parameter is not specifed, helios_config_set.pl will default 
to the current host.  If you want a parameter to take effect for a service 
across an entire collective, set the --hostname parameter to '*'. 

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
