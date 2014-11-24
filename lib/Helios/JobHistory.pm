package Helios::JobHistory;

# [LH] [2014-11-16]: Completely replaced the old Helios 2.x class.  This new 
# class is a Helios Foundation Class, instead of a Data::ObjectDriver-based
# class.

use 5.008;
use strict;
use warnings;
use constant MAX_RETRIES    => 3;
use constant RETRY_INTERVAL => 5;
use Time::HiRes 'time';

use Helios::Config;
use Helios::ObjectDriver;
use Helios::Error;
use Helios::Error::JobHistoryError;
use Helios::JobHistoryEntry;

our $VERSION = '2.90_0000';

use Class::Tiny qw(
		jobhistoryid
		jobid
		jobtypeid
		args
		insert_time		
		priority		
		uniqkey
		coalesce
		complete_time
		exitstatus

		run_after
		locked_until

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
		return $self->inflate($params->{obj});
	}
}



sub setJobhistoryid {
	$_[0]->jobhistoryid($_[1]);	
}
sub getJobhistoryid {
	$_[0]->jobhistoryid();
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

sub setArgs {
	$_[0]->args($_[1]);	
}
sub getArgs {
	$_[0]->args();
}

sub setInsertTime {
	$_[0]->insert_time($_[1]);	
}
sub getInsertTime {
	$_[0]->insert_time();
}

sub setPriority {
	$_[0]->priority($_[1]);	
}
sub getPriority {
	$_[0]->priority();
}

sub setUniqkey {
	$_[0]->uniqkey($_[1]);	
}
sub getUniqkey {
	$_[0]->uniqkey();
}

sub setCoalesce {
	$_[0]->coalesce($_[1]);	
}
sub getCoalesce{
	$_[0]->coalesce();
}

sub setCompleteTime {
	$_[0]->complete_time($_[1]);	
}
sub getCompleteTime {
	$_[0]->complete_time();
}

sub setExitstatus {
	$_[0]->exitstatus($_[1]);	
}
sub getExitstatus {
	$_[0]->exitstatus();
}


# secondary methods

sub setRunAfter {
	$_[0]->run_after($_[1]);	
}
sub getRunAfter {
	$_[0]->run_after();
}

sub setLockedUntil {
	$_[0]->locked_until($_[1]);	
}
sub getLockedUntil {
	$_[0]->locked_until();
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
#	$self->setDriver($d);
	return $d;
}


=head1 OBJECT INITIALIZATION

=head2 inflate()

If a basic system object is passed to new() using the 'obj' parameter, 
inflate() will be called to expand the elemental object into the full Helios
object.

=cut

sub inflate {
	my $self = shift;
	my $obj = shift;
	# we were given an object to inflate from
	$self->_obj( $obj);
	$self->jobhistoryid( $obj->jobhistoryid);
	$self->jobid( $obj->jobid);
	$self->jobtypeid( $obj->jobtypeid);
	$self->args( $obj->args);
	$self->insert_time( $obj->insert_time);
	$self->run_after( $obj->run_after);
	$self->locked_until( $obj->locked_until);
	$self->priority( $obj->priority);
	$self->uniqkey( $obj->uniqkey);
	$self->coalesce( $obj->coalesce);
	$self->complete_time( $obj->complete_time);
	$self->exitstatus( $obj->exitstatus);

	return $self;
}


=head1 CLASS METHODS

=head2 lookup([jobhistoryid => $id]|[jobid => $jobid])

=cut

sub lookup {
	my $self = shift;
	my %params = @_;
	my $id        = $params{jobhistoryid};
	my $jobid     = $params{jobid};
	my $config    = $params{config};
	my $debug     = $params{debug} || 0;
	my $drvr;
	my $obj;
	
	# throw an error if we don't have either name or object id
	unless ($id || $jobid) {
		Helios::Error::JobHistoryError->throw('Helios::JobHistory->lookup(): Either a jobhistoryid or jobid is required.');
	}

	eval {
		$drvr = Helios::ObjectDriver->getDriver(config => $config);
		if ($id) {
			# use object id!
			$obj = $drvr->lookup('Helios::JobHistoryEntry' => $id);
		} else {

			# use jobid
			$obj = $self->lookup_by_jobid(jobid => $jobid, config => $config);
		}
		
		1;
	} or do {
		my $E = $@;
		Helios::Error::JobHistoryError->throw('lookup(): '."$E");
	};
	
	if (defined($obj)) {
		# we found it!
		return Helios::JobHistory->new(
			obj    => $obj, 
			driver => $drvr, 
			config => Helios::ObjectDriver->getConfig(),
			debug  => $debug,
		);		
	} else {
		# we didn't find it
		return undef;
	}
}


sub lookup_by_jobid {
	my $self = shift;
	my %params = @_;
	my $jobid = $params{jobid};
	my $config = $params{config};

	my $drvr;
	my $itr;
	my $obj;
	
	eval {
		$drvr = $self->getDriver(config => $config);
		$itr = $drvr->search(
			'Helios::JobHistoryEntry' => 
				{ jobid => $jobid },
				{ sort => 'complete_time', direction => 'descend'}
		);
		$obj = $itr->next();
		
		1;
	} or do {
		my $E = $@;
		Helios::Error::JobHistoryError->throw("lookup(): $E");
	};
	
	return $obj;
}


sub lookup_by_jobid_full {
	my $self   = shift;
	my %params = @_;
	my $jobid  = $params{jobid};
	my $config = $params{config};
	my $debug  = $params{debug};

	my $drvr;
	my $itr;
	my @history;
	my @entries;
	
	eval {
		$drvr = $self->getDriver(config => $config);
		@entries = $drvr->search(
			'Helios::JobHistoryEntry' => 
				{ jobid => $jobid },
				{ sort => 'complete_time', direction => 'ascend'}
		);
		
		1;
	} or do {
		my $E = $@;
		Helios::Error::JobHistoryError->throw("lookup(): $E");
	};

	foreach(@entries) {

		push(
			@history,
			Helios::JobHistory->new(
				obj    => $_,
				config => $config,
				driver => $drvr,
				debug  => $debug,
			)
		);
	}
	
	if (@history) {
		return @history;
	} else {
		return undef;
	}
}


=head1 OBJECT METHODS

=head2 submit()

=cut

sub create {
	my $self = shift;
	my %params = @_;
	my $config = $self->getConfig();
	my $jobid        = $params{jobid}         || $self->getJobid;
	my $jobtypeid    = $params{jobtypeid}     || $self->getJobtypeid;
	my $args         = $params{args}          || $self->getArgs;
	my $inserttime   = $params{insert_time}   || $self->getInsertTime;
	my $runafter     = $params{run_after}     || $self->getRunAfter      || 0;
	my $lockeduntil  = $params{locked_until}  || $self->getLockedUntil   || 0;
	my $priority     = $params{priority}      || $self->getPriority;
	my $uniqkey      = $params{uniqkey}       || $self->getUniqkey;
	my $coalesce     = $params{coalesce}      || $self->getCoalesce;
	my $completetime = $params{complete_time} || $self->getCompleteTime;
	my $exitstatus   = $params{exitstatus}    || $self->getExitstatus;

	my $id;
	my $obj;
	
	unless ($jobid && $jobtypeid && $args) {
		Helios::Error::JobHistoryError->throw("submit(): The following fields are required: jobid, jobtypeid, arg.");
	}
	
	eval {
		my $drvr = $self->getDriver(config => $config);
		$obj = Helios::JobHistoryEntry->new(
			jobid         => $jobid,
			jobtypeid     => $jobtypeid,
			args          => $args,
			insert_time   => $inserttime,
			run_after     => $runafter,
			locked_until  => $lockeduntil,
			priority      => $priority,
			uniqkey       => $uniqkey,
			coalesce      => $coalesce,
			complete_time => defined($completetime) ? $completetime : time(),
			exitstatus    => $exitstatus,			
		);
		$drvr->insert($obj);
		1;
	} or do {
		my $E = $@;
		Helios::Error::JobHistoryError->throw("submit(): $E");
	};
	# use the new elemental object to (re)inflate $self
	$self->inflate($obj);
	# the calling routine expects to receive the id
	return $self->getJobhistoryid;
}


=head2 remove()

=cut

sub remove {
	my $self = shift;
	my $id = $self->getJobhistoryid;
	my $drvr;
	my $r;
	
	# we actually need the elemental object here, because we're going to use
	# D::OD to do the delete operation.
	unless ($self->{_obj} && $id) {
		Helios::Error::JobHistoryError->throw('remove(): Helios::JobHistory object was not properly initialized; cannot remove.');
	}
	
	eval {
		$drvr = $self->getDriver();
		$drvr->remove($self->{_obj});
		1;
	} or do {
		my $E = $@;
		Helios::Error::JobHistoryError->throw("remove(): $E");
	};
	# signal the calling routine remove was successful 
	return 1;
}


=head2 submit() 

=cut

sub submit {
	my $self = shift;
	my %params = @_;
	
	my $success = 0;
	my $retries = 0;
	my $error   = '';
	my $jobhistoryid;
	
	do {
		eval {
			$jobhistoryid = $self->create(%params);
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
	
	if ($success && $jobhistoryid) {
		return $jobhistoryid;
	} else {
		Helios::Error::JobHistoryError->throw("submit(): $error");
	}
	
}



1;
__END__

