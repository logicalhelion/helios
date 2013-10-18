#!/usr/bin/env perl

use 5.008;
use strict;
use warnings;
use Getopt::Long;
use Data::Dumper; #[]
use Config::IniFiles; 	# we'll be using this directly to parse the input file

use Helios::Config;
use Helios::Error;
use Helios::ObjectDriver::DBI;	#[] change to H::OD later

our $VERSION = '2.71_4250';

our $Debug = 0;
our $Help_Mode = 0;
our $Verbose = 0;
our $Import_File;

GetOptions(
	"file=s"  => \$Import_File,
	"debug"   => \$Debug,
	"help"    => \$Help_Mode,
	"verbose" => \$Verbose
);

if ( $Help_Mode ) {
	require Pod::Usage;
	Pod::Usage::pod2usage(-verbose => 2, -exitstatus => 0);
}

# debug auto-enables verbose
if ($Debug) { $Verbose = 1; }

my $cif = Config::IniFiles->new( -file => $Import_File );
unless ( defined($cif) ) { 
	# @Config::IniFiles::errors contains the parse error(s);
	my $E = join("\n", @Config::IniFiles::errors);
	warn("Errors found parsing file $Import_File:\n ".$E);
	exit(1);
}
print "Conf file $Import_File parsed.\n" if $Verbose;

my @sections = $cif->Sections();
print "Found ",scalar @sections," sections in file.\n" if $Verbose;
print join("\n", @sections),"\n" if $Debug;

my $config_struct;
my $param_cnt = 0;
foreach my $section (@sections) {
	# skip [global]
	next if $section =~ /^global/i;
	my ($sec, $host);
	if ( $section =~ /\|/) {
		($sec, $host) = split(/\|/, $section);
	} else {
		$sec = $section;
		$host = '*';
	}

	foreach ( $cif->Parameters($section) ) {
		$config_struct->{$sec}->{$host}->{$_} = $cif->val($section, $_);
		$param_cnt++;
	}
}

print Dumper($config_struct);	#[]

print "Found $param_cnt parameters for ", 
	scalar keys %$config_struct, " services.\n";

# OK, we've built the config structure we want to import
# use Helios::Config to the actual importing
my $conf = Helios::Config->parseConfig();

my $imp_cnt = 0;
foreach my $class (keys %$config_struct) {
	foreach my $host ( keys %{ $config_struct->{$class} }) {
		foreach my $param (keys %{ $config_struct->{$class}->{$host} } ) {
			Helios::Config->setParam(
				service_name => $class,
				hostname     => $host,
				param        => $param,
				value        => $config_struct->{$class}->{$host}->{$param}
			);
			print "$class|$host|$param set to ", $config_struct->{$class}->{$host}->{$param} ,"\n" if $Verbose;
			$imp_cnt++;
		}
	}
}

print $imp_cnt," config parameters imported to Helios collective database.\n";

exit(0);

