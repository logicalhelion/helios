#!/usr/bin/env perl

use 5.008;
use strict;
use warnings;
use Getopt::Long;
use Sys::Hostname;

use Helios::Service;

our $VERSION = '2.71_4350';

our $Service_Name = '';
our $Hostname     = '';
our $Help_Mode    = 0;

GetOptions(
	"service=s"  => \$Service_Name,
	"hostname=s" => \$Hostname, 
	"help"       => \$Help_Mode,
);

# help mode
if ($Help_Mode) {
	require Pod::Usage;
	Pod::Usage::pod2usage(-verbose => 2, -exitstatus => 0);
}

# this is a little old school, but we'll 
# instantiate the base Helios::Service to 
# get a collective database connection
my $s = Helios::Service->new();
$s->prep();
my $dbh = $s->dbConnect();

my @placeholders;
my $sql = q{
	SELECT 
		worker_class, 
		worker_version, 
		host, 
		process_id, 
		start_time, 
		register_time
	FROM
		helios_worker_registry_tb
	WHERE
		register_time > ?
		
};
push(@placeholders, time() - 300 );

if ($Service_Name) { 
	$sql .= ' AND worker_class = ? ';
	push(@placeholders, $Service_Name);
}

if ($Hostname) {
	$sql .= ' AND host = ? ';
	push(@placeholders, $Hostname);
}

my $rs;
eval {
	$rs = $dbh->selectall_arrayref($sql, undef, @placeholders);
	1;
} or do {
	my $E = $@;
	warn "$0: ERROR: $E\n";
	exit(1);
};

foreach (@$rs) {
	print 'Service: ',$_->[0],' ',$_->[1],'  Host: ',$_->[2],'  PID: ',$_->[3],"\n";
	print "  Online Since: ",scalar localtime($_->[4]),'  Last Registered: ',scalar localtime($_->[5]),"\n";
}

$dbh->disconnect();


exit(0);

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
