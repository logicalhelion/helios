#!/usr/bin/env perl

use 5.008;
use strict;
use warnings;
use Getopt::Long;

use Helios::Service;

our $VERSION = '2.71_4350';

our $Args;
our @JobHistory;
our @Logs;

our $OPT_JOBID = '';
our $OPT_HELP    = 0;

GetOptions(
	"jobid=s" => \$OPT_JOBID,
	"help"    => \$OPT_HELP,
);

# help mode
if ($OPT_HELP) {
	require Pod::Usage;
	Pod::Usage::pod2usage(-verbose => 2, -exitstatus => 0);
}

unless ($OPT_JOBID) {
	warn "$0: A jobid is required.\n";
	exit(1);
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
		exitstatus
	FROM
		helios_job_history_tb
	WHERE
		jobid = ?
	ORDER BY complete_time DESC
		
};
push(@placeholders, $OPT_JOBID );

my @rs;
eval {
	@rs = @{ $dbh->selectall_arrayref($sql, undef, @placeholders) };
	1;
} or do {
	my $E = $@;
	warn "$0: ERROR: $E\n";
	exit(1);
};

if ( @rs ) {
	print $rs[0]->[0],"\n";
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
