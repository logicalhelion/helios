package Helios::Logger::Default;

use 5.008;
use strict;
use warnings;
use parent 'Helios::Logger';
use constant MAX_RETRIES    => 3;
use constant RETRY_INTERVAL => 5;
use Time::HiRes 'time';

use Helios::LogEntry;
use Helios::LogEntry::Levels ':all';
use Helios::Error::LoggingError;


sub init { }

sub logMsg {
	my $self = shift;
	my ($job, $priority, $message) = @_;

	my $success = 0;
	my $retries = 0;
	my $err;

	my $jobid = defined($job) ? $job->getJobid() : undef;
	my $jobtypeid = defined($job) ? $job->getJobtypeid() : undef;
	
	do {
		eval {

			my $drvr = $self->getDriver();
			my $obj = Helios::LogEntry->new(
				log_time  => sprintf("%.6f", time()),
				host      => $self->getHostname(),
				pid       => $$,
				jobid     => $jobid,
				jobtypeid => $jobtypeid,
				service   => $self->getService(),
				priority  => defined($priority) ? $priority : LOG_INFO,
				message   => $message,
			);
			$drvr->insert($obj);
			1;
		};
		if ($@) {
			$err = $@;
			$retries++;
			sleep RETRY_INTERVAL;
		} else {
			# no exception? then declare success and move on
			$success = 1;
		}
	} until ($success || ($retries > MAX_RETRIES));
	
	unless ($success) {
		Helios::Error::LoggingError->throw("Helios::Logger::Default->logMsg() ERROR: $err");
	}
	
	return 1;	
}

1;
__END__


=head1 AUTHOR

Andrew Johnson, E<lt>lajandy at cpan dot orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Logical Helion, LLC.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=head1 WARRANTY

This software comes with no warranty of any kind.

=cut

