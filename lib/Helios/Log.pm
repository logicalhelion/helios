package Helios::Log;

use 5.008;
use strict;
use warnings;
use constant MAX_RETRIES    => 3;
use constant RETRY_INTERVAL => 5;
use Sys::Hostname ();
use Time::HiRes 'time';

use Helios::ObjectDriver;
use Helios::LogEntry;
use Helios::LogEntry::Levels ':all';
use Helios::Error;
use Helios::Error::LoggingError;

our $VERSION = '2.90_0000';

use Class::Tiny qw(
		logid
		log_time
		host
		pid
		jobid
		jobtypeid
		service
		priority
		message		

		_obj
		debug
		driver
		config
);


sub BUILD {
	my ($self, $params) = @_;

	# if we were given a basic object, inflate our object from it
	# otherwise, our BUILD() is done
	if ($params->{obj}) {
		$self->inflate($params->{obj});
	} 
}


=head1 ACCESSOR METHODS

=cut

sub setLogid {
	$_[0]->logid($_[1]);	
}
sub getLogid {
	$_[0]->logid();
}

sub setLogTime {
	$_[0]->log_time($_[1]);	
}
sub getLogTime {
	$_[0]->log_time();
}

sub setHost {
	$_[0]->host($_[1]);	
}
sub getHost {
	$_[0]->host();
}

sub setPid {
	$_[0]->pid($_[1]);	
}
sub getPid {
	$_[0]->pid();
}

sub setJobid {
	$_[0]->jobid($_[1]);	
}
sub getJobid {
	$_[0]->jobid();
}

sub setJobtypeid {
	$_[0]->jobtypeid($_[1]);	
}
sub getJobtypeid {
	$_[0]->jobtypeid();
}

sub setService {
	$_[0]->service($_[1]);	
}
sub getService {
	$_[0]->service();
}

sub setPriority {
	$_[0]->priority($_[1]);	
}
sub getPriority {
	$_[0]->priority();
}

sub setMessage {
	$_[0]->message($_[1]);	
}
sub getMessage {
	$_[0]->message();
}

sub setConfig {
	$_[0]->config($_[1]);
}
sub getConfig {
	$_[0]->config();
}

sub setDriver {
	$_[0]->driver($_[1]);	
}
sub getDriver {
	initDriver(@_);
}
sub initDriver {
	my $self = shift;
	my $d = Helios::ObjectDriver->getDriver(@_);
	$self->setDriver($d);
	$d;
}




=head2 inflate()

If a basic system object is passed to new() the 'obj' parameter, 
inflate() will be called to expand the basic object into the full Helios
Foundation Class object.

=cut

sub inflate {
	my $self = shift;
	my $obj = shift;
	# we were given an object to inflate from
	$self->_obj( $obj );
	$self->logid( $obj->logid);
	$self->log_time( $obj->log_time);
	$self->host( $obj->host);
	$self->pid( $obj->pid);
	$self->jobid( $obj->jobid);
	$self->jobtypeid( $obj->jobtypeid);
	$self->service( $obj->service);
	$self->priority( $obj->priority);
	$self->message( $obj->message);		

	return $self;
}


=head1 CLASS METHODS

=head2 lookup()


=cut

sub lookup {
	my $self = shift;
	my %params = @_;
	my $id        = $params{logid};
	my $config    = $params{config};
	my $debug     = $params{debug} || 0;
	my $drvr;
	my $obj;
	
	# throw an error if we don't have logid
	unless ($id) {
		Helios::Error::LoggingError->throw('lookup(): A logid is required.');		
	}

	eval {
		$drvr = Helios::ObjectDriver->getDriver(config => $config);
		if ($id) {
			# use $id!
			$obj = $drvr->lookup('Helios::LogEntry' => $id);
		}			
		1;
	} or do {
		my $E = $@;
		Helios::Error::Fatal->throw('lookup(): '."$E");
	};
	
	if (defined($obj)) {
		# we found it!
		return Helios::Log->new(
			obj => $obj, 
			driver => $drvr, 
			config => Helios::ObjectDriver->getConfig(),
			debug  => $debug,
		);		
	} else {
		# we didn't find it
		return undef;
	}
}


sub lookup_by_jobid_full {
	my $self   = shift;
	my %params = @_;
	my $jobid  = $params{jobid};
	my $config = $params{config};
	my $debug  = $params{debug};

	my $drvr;
	my $itr;
	my @logs;
	my @entries;
	
	eval {
		$drvr = $self->getDriver(config => $config);
		@entries = $drvr->search(
			'Helios::LogEntry' => 
				{ jobid => $jobid },
#[]				{ sort => 'log_time', direction => 'ascend'}
				{ sort => [ {column => 'log_time', direction => 'ascend'}, {column => 'logid', direction => 'ascend'} ] }
		);
		
		1;
	} or do {
		my $E = $@;
		Helios::Error::LogError->throw("lookup(): $E");
	};

	foreach(@entries) {
		push(
			@logs,
			Helios::Log->new(
				obj    => $_,
				config => $config,
				driver => $drvr,
				debug  => $debug,
			)
		);
	}
	
#	if (@logs) {
#		return @logs;
#	} else {
#		return undef;
#	}
	return @logs;
}

=head1 OBJECT METHODS

=head2 create()

=cut

sub create {
	my $self = shift;
	my %params = @_;
	my $config = $params{config} || $self->getConfig();
	
	my $log_time  = $params{log_time}  || $self->getLogTime();
	my $host      = $params{host}      || $self->getHost();
	my $pid       = $params{pid}       || $self->getPid();
	my $jobid     = $params{jobid}     || $self->getJobid()     || undef;
	my $jobtypeid = $params{jobtypeid} || $self->getJobtypeid() || undef;
	my $service   = $params{service}   || $self->getService();
	my $priority  = $params{priority}  || $self->getPriority();
	my $message   = $params{message}   || $self->getMessage();

	my $id;
	my $obj;
	
	unless ($message) {
		Helios::Error::LoggingError->throw('create(): A message is required to create a log message.');
	}

	# DEFAULTS:  $log_time, $host, $pid, $priority
	# host is here instead of in new() because a DNS lookup may take time
	# and throw the log_time value off
	# In practice, the Helios layers above Helios::Log should provide 
	# a pre-resolved host when they call new()
	# (theoretically) #[]
	$host     = defined($host)     ? $host     : Sys::Hostname::hostname();
	
	eval {
		my $drvr = $self->getDriver(config => $config);
		$obj = Helios::LogEntry->new(
			log_time  => defined($log_time) ? $log_time : time(),
			host      => $host,
			pid       => defined($pid)      ? $pid      : $$,
			jobid     => $jobid,
			jobtypeid => $jobtypeid,
			service   => $service,
			priority  => defined($priority) ? $priority : LOG_INFO,
			message   => $message, 
		);
		$drvr->insert($obj);
		1;
	} or do {
		my $E = $@;
		Helios::Error::LoggingError->throw("create(): $E");
	};
	# use the new elementary object to (re)inflate $self
	$self->inflate($obj);
	# the calling routine expects to receive the jobtypeid
	return $self->getLogid();
}


=head2 remove()

=cut

sub remove {
	my $self = shift;
	my $id = $self->getLogid;
	my $drvr;
	my $r;
	
	# we actually need the FuncMap object here, because we're going to use
	# D::OD to do the delete operation.
	unless ($self->{_obj} && $id) {
		Helios::Error::LoggingError->throw('remove(): Helios::Log object was not properly initialized; cannot remove.');
	}
	
	eval {
		$drvr = $self->getDriver();
		$drvr->remove($self->{_obj});

		1;
	} or do {
		my $E = $@;
		Helios::Error::LoggingError->throw("remove(): $E");
	};
	# signal the calling routine remove was successful 
	return 1;
}


=head2 logMsg($job_obj, $log_priority, $message) 

=cut

sub log_msg {
	my $self = shift;
	my %params = @_;
	
	my $success = 0;
	my $retries = 0;
	my $error   = '';
	my $logid;
	
	do {
		eval {
			$logid = $self->create();
		};
		if ($@) {
			$error = $@;
			$retries++;
			sleep RETRY_INTERVAL;
		} else {
			# no exception? then declare success and move on
			$success = 1;
		}
	} until ($success || ($retries > MAX_RETRIES));
	
	if ($success && $logid) {
		return $logid;
	} else {
		Helios::Error::LoggingError->throw("log_msg(): $error");
	}
	
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

