package Helios::Job;

# [LH] [2014-11-16]: Completely replaced the old Helios 2.x class.  This new 
# class is a complex Helios Foundation Class which uses the other HeFC classes 
# for many of its functions.

use 5.008;
use strict;
use warnings;

use XML::Tiny ();

use Helios::ObjectDriver;
use Helios::JobType;
use Helios::JobHistory;
use Helios::Log;
use Helios::TS::Job;
use Helios::Error::JobError;	#[]? load all errors, or just JobError?

our $VERSION = '2.90_0000';

use Class::Tiny qw(
		jobid          
		jobtypeid     
		args          
		jobtype       
		arg_string     
		insert_time   
		complete_time 
		exitstatus    

		run_after     
		locked_until 
		failures      
		uniqkey       
		coalesce      
		priority      

		_obj      
		debug     
		driver    
		config    
);

sub JobHistoryClass { 'Helios::JobHistory' }
sub JobTypeClass { 'Helios::JobType' }
sub LogClass { 'Helios::Log' }


sub BUILD {
	my ($self, $params) = @_;

	# if we were given a basic system object, inflate our object from it
	# otherwise, our BUILD() is done
	if ($params->{obj}) {
		return $self->inflate($params->{obj});
	}
}


sub setArgs {
	$_[0]->args($_[1]);	
}
sub getArgs {
	$_[0]->args;
}

sub setArgString {
	$_[0]->arg_string($_[1]);	
}
sub getArgString {
	$_[0]->arg_string();
}

sub setJobType {
	$_[0]->jobtype($_[1]);	
}
sub getJobType {
	if ( defined($_[0]->jobtype) ) {
		return $_[0]->jobtype;
	} elsif ( defined($_[0]->jobtypeid) ) {
		$_[0]->jobtype( $_[0]->lookup_job_type( $_[0]->jobtypeid )->getName() );
		return $_[0]->jobtype;
	} else {
		return undef;
	}
}
sub lookup_job_type {
	my $self = shift;
	my $jobtypeid = @_ ? shift : $self->jobtypeid;
	Helios::Error::JobError->throw("Helios::Job->lookup_job_type(): A jobtypeid is required.") unless defined($jobtypeid);	

	my $jt = Helios::JobType->lookup(config => $self->config, jobtypeid => $jobtypeid);
	if ( defined($jt) ) {
		return $jt;		
	} else {
		Helios::Error::JobError("Helios::Job->lookup_job_type(): A jobtype of jobtypeid => $jobtypeid does not exist in the Helios collective database.");
	}
}


sub setJobtypeid {
	$_[0]->jobtypeid($_[1]);	
}
sub getJobtypeid {
	$_[0]->jobtypeid;
}

sub setInsertTime {
	$_[0]->insert_time($_[1]);	
}
sub getInsertTime {
	$_[0]->insert_time;
}

sub setPriority {
	$_[0]->priority($_[1]);	
}
sub getPriority {
	$_[0]->priority;
}

sub setUniqkey {
	$_[0]->uniqkey($_[1]);	
}
sub getUniqkey {
	$_[0]->uniqkey;
}

sub setCoalesce {
	$_[0]->coalesce($_[1]);	
}
sub getCoalesce{
	$_[0]->coalesce;
}

sub setCompleteTime {
	$_[0]->complete_time($_[1]);	
}
sub getCompleteTime {
	$_[0]->complete_time;
}

sub setExitstatus {
	$_[0]->exitstatus($_[1]);	
}
sub getExitstatus {
	$_[0]->exitstatus;
}


# secondary methods

sub setRunAfter {
	$_[0]->run_after($_[1]);	
}
sub getRunAfter {
	$_[0]->run_after;
}

sub setLockedUntil {
	$_[0]->locked_until($_[1]);	
}
sub getLockedUntil {
	$_[0]->locked_until;
}


sub setJobid {
	$_[0]->jobid($_[1]);	
}
sub getJobid {
	$_[0]->jobid;
}

sub setConfig {
	$_[0]->config($_[1]);
}
sub getConfig {
	$_[0]->config;
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
#[]	$self->setDriver($d);
	return $d;
}

=head1 OBJECT INITIALIZATION

=head2 inflate()

If a basic system object is passed to new() using the 'obj' parameter, 
inflate() will be called to expand the basic object into the full Helios
Foundation Class object.

=cut

sub inflate {
	my $self = shift;
	my $obj = shift;
	# we were given an object to inflate from
	$self->_obj( $obj );

	# we can inflate from 
	# Helios::TS::Job objects
	# OR
	# Helios::JobHistory objects
	if ( ref($obj) ) {
		if ( $obj->isa('Helios::TS::Job') ) {
			$self->inflate_from_ts_job($obj);
		} elsif ( $obj->isa('Helios::JobHistory') ) {
			$self->inflate_from_job_history($obj);
		} else {
			Helios::Error::JobError->throw("Cannot inflate a Helios::Job from object of class ". ref($obj));
		}		
	} else {
		Helios::Error::JobError->throw("Cannot inflate a Helios::Job from a non-object.");
	}

	return $self;
}

sub inflate_from_ts_job {
	my $self = shift;
	my $obj = shift;

	$self->jobid( $obj->jobid()); 
	$self->jobtypeid($obj->funcid());
	$self->arg_string($obj->arg()->[0]);
#[]	$self->failures($obj->failures());
#[]	$self->jobtype($obj->jobtype());
	$self->uniqkey($obj->uniqkey());
	$self->run_after($obj->run_after());
	$self->locked_until($obj->grabbed_until());
	$self->coalesce($obj->coalesce());
#[]	$self->arg_string($obj->arg_string());
	$self->priority($obj->priority());
	$self->insert_time($obj->insert_time());
#[]	$self->complete_time($obj->complete_time());
#[]	$self->exitstatus($obj->exitstatus());

	my $arg_obj = $self->deserialize_arg_string($self->arg_string); 
 	$self->args( $arg_obj->{args} );

	#[] what about:
	# failures?
	# jobtype?
	
	return $self;
}

sub inflate_from_job_history {
	my $self = shift;
	my $obj = shift;
	
	$self->jobid( $obj->jobid ); 
	$self->jobtypeid( $obj->jobtypeid );
	$self->arg_string( $obj->args );
#[]	$self->failures($obj->failures());
#[]	$self->jobtype($obj->jobtype());
	$self->uniqkey( $obj->uniqkey );
	$self->run_after( $obj->run_after );
	$self->locked_until( $obj->locked_until );
	$self->coalesce( $obj->coalesce );
	$self->priority( $obj->priority );
	$self->insert_time( $obj->insert_time );
	$self->complete_time( $obj->complete_time() );
	$self->exitstatus( $obj->exitstatus() );

	#[]?
	# failures?
	# jobtype?

	my $arg_obj = $self->deserialize_arg_string($self->arg_string); 
 	$self->args( $arg_obj->{args} );

	return $self;	
}


sub inflate_from_string {
	my $self = shift;
	my $str = shift;
	
	Helios::Error::JobError->throw("Helios::Job->inflate_from_string(): NOT IMPLEMENTED.");
}


sub deserialize_arg_string {
	my $self = shift;
	my $argstr = shift;
	
	if ( $argstr =~ /^\s*\{/ ) {
		# JSON args!
		return $self->deserialize_arg_string_json($argstr);
	} elsif ( $argstr =~ /^\s*\</ ) {
		return $self->deserialize_arg_string_xml($argstr);
	} else {
		Helios::Error::JobError->throw("deserialize_arg_string(): Job arg_string in unrecognized format.");
	}
}


sub deserialize_arg_string_json {
	my $self = shift;
	my $argstr = shift;
	my $argobj;
	
	eval {
		use JSON::Tiny 'decode_json';
		local $JSON::Tiny::TRUE = 1;
		local $JSON::Tiny::FALSE = 0;		
		$argobj = decode_json($argstr);
		1;		
	} or do {
		my $E = $@;
		# rethrow JSON::Tiny's error as a JobError
		Helios::Error::JobError->throw("deserialize_arg_string_json(): $E");
	};
	$argobj;
}


sub deserialize_arg_string_xml {
	my $self = shift;
	my $argstr = shift;
	my $argstruct;
	
	eval {
		use XML::Tiny ();
		my $args = XML::Tiny::parsefile('_TINY_XML_STRING_'.$argstr);
		unless ($args->[0]->{name} eq 'job') { die("Root element is not 'job'"); }
		if ( defined $args->[0]->{jobtype} ) {
    		$argstruct->{jobtype} = $args->[0]->{jobtype};
		}
		foreach my $jobsection ( @{ $args->[0]->{content} } ) {
	    	if ( $jobsection->{name} eq 'jobtype' ) {
        		$argstruct->{jobtype} = $jobsection->{content}->[0]->{content};
    		} elsif ( $jobsection->{name} eq 'args' || $jobsection->{name} eq 'params') {
        		foreach my $argsection ( @{ $jobsection->{content} } ) {
            		my $name = $argsection->{name};
            		$argstruct->{args}->{ $name } = $argsection->{content}->[0]->{content};
        		}
    		}
    		# any other sections, ignore
		}
		
		1;
	} or do {
		my $E = $@;
		# rethrow XML::Tiny's error as a JobError
		Helios::Error::JobError->throw("Helios::Job->deserialize_arg_string_xml(): $E");		
	};

	$argstruct;
}


sub serialize_args {
	my $self = shift;
	my $args = @_ ? shift : $self->getArgs();
	
	my $argstr = $self->serialize_args_json($args);
	
	$self->setArgString($argstr);	
	$argstr;	
}

sub serialize_args_json {
	my $self = shift;
	my $argsref = @_ ? shift : $self->getArgs();
	my $argstr;
	
	eval {
		use JSON::Tiny 'encode_json';
		local $JSON::Tiny::TRUE = 1;
		local $JSON::Tiny::FALSE = 0;		
		$argstr = encode_json($argsref);
		1;		
	} or do {
		my $E = $@;
		# rethrow JSON::Tiny's error as a JobError
		Helios::Error::JobError->throw("Helios::Job->serialize_args_json(): $E");
	};
	$argstr;
}

sub serialize_args_xml {
	my $self = shift;
	Helios::Error::JobError("not implemented yet");	
}


=head1 CLASS METHODS

=head2 lookup()


=cut

sub lookup {
	my $self = shift;
	my %params = @_;
	my $id        = $params{jobid};
	my $config    = $params{config};
	my $debug     = $params{debug} || 0;
	my $drvr;
	my $obj;
	
	# throw an error if we don't have either a jobid
	unless ($id) {
		Helios::Error::JobError->throw('Helios::Job->lookup():  A jobid is required.');
	}

	eval {
		$drvr = Helios::ObjectDriver->getDriver(config => $config);
		$obj = $drvr->lookup('Helios::TS::Job' => $id);
		
		if (!defined($obj)) {
			# jobid wasn't in the job queue, look in job history
			$obj = Helios::JobHistory->lookup(
				jobid  => $id,
				config => $config,
				driver => $drvr,
			);
		}

		1;
	} or do {
		my $E = $@;
		Helios::Error::JobError->throw('lookup(): '."$E");
	};
	
	if (defined($obj)) {
		# we found it!
		# (add the driver object to the job to make job completion work) #[]
		$obj->{__driver} = $drvr;
		return Helios::Job->new(
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


=head1 OBJECT METHODS

=head2 create()

=cut

sub create {
	my $self = shift;
	my %params = @_;
	my $config = $self->getConfig();
	my $argstr    = $params{arg_string} || $self->getArgString();
	my $jobtype   = $params{jobtype}    || $self->getJobType();
	my $jobtypeid = $params{jobtypeid}  || $self->getJobtypeid();

	my $obj;

	unless ( defined($argstr) ) { Helios::Error::JobError->throw("Helios::Job->create():  An arg_string is required to create a job."); }
	unless ( defined($jobtype) || defined($jobtypeid) ) { 
		Helios::Error::JobError->throw("Helios::Job->create():  A jobtype or jobtypeid is required to create a job."); 
	}

	# use pieces of TheSchwartz to create a new job in the job table 
	# we're *using* TheSchwartz::Job->new_from_array()
	# we're *replacing* TheSchwartz->insert_job_to_driver()
	
	# new_from_array() expects a structure
	my $arg_struct = [ $argstr ];
	
	eval {
		my $drvr = $self->getDriver(config => $config);
		$obj = Helios::TS::Job->new_from_array($jobtype, $arg_struct);

		# add the insert_time and funcid (jobtypeid)
		$obj->insert_time( time() );
		$obj->funcid( $jobtypeid );

		# insert the job!
		$drvr->insert($obj);
		1;
	} or do {
		my $E = $@;
		Helios::Error::JobError->throw("Helios::Job->create(): $E");
	};

	# use the new Helios::TS::Job object to (re)inflate $self
	$self->inflate($obj);
	# the calling routine expects to receive the jobid
	return $self->getJobid();
}


=head2 remove()

The remove() method deletes a job from the Helios collective database.  
It returns 1 if successful and throws a Helios::Error::JobError if the 
removal operation fails.

USE WITH CAUTION.  All Helios jobs, both enqueued and completed, have an
associated jobtype, and removing a jobtype that still has associated jobs in 
the system will have unintended consequences!

THROWS:  Helios::Error::JobError if the removal operation fails.

=cut

sub remove {
	my $self = shift;
	my $jobid = $self->getJobid();
	my $drvr;
	my $r;
	
	# we actually need the Helios::TS::Job object here, because we're going to use
	# D::OD to do the delete operation.
	unless ($self->{_obj} && $jobid) {
		Helios::Error::JobError->throw('Helios::Job->remove(): Helios::Job object was not properly initialized; cannot remove.');
	}
	
	eval {
		$drvr = $self->getDriver();
		$drvr->remove($self->{_obj});
		1;
	} or do {
		my $E = $@;
		Helios::Error::JobError->throw("Helios::Job->remove(): $E");
	};
	
	# signal the calling routine remove was successful 
	return 1;
}


=head2 submit()

=cut

sub submit {
	my $self = shift;
	my %params = @_;
	my $config = $self->getConfig();
	my $argstr    = $params{arg_string}|| $self->getArgString();
	my $jobtype   = $params{jobtype}   || $self->getJobType();
	my $jobtypeid = $params{jobtypeid} || $self->getJobtypeid();
	my $args      = $params{args}      || $self->getArgs();

	my $obj;
	my $id;

	# if we don't have an argstring, 
	# but we do have args,
	# serialize the args into a string
	unless ( $argstr || defined($args) ) {
		Helios::Error::JobError->throw("submit(): Job arguments (either an arg_string or hashref) are required to submit a job."); 
	}
	if ( !$argstr ) {
		$argstr = $self->serialize_args($args);
		unless ($argstr) { Helios::Error::JobError->throw("submit():  Job arg_string is empty."); }
	}
	
	
	# if we have a jobtype but not a jobtypeid, 
	# use Helios::JobType to lookup the jobtypeid
	unless ( defined($jobtype) ) { Helios::Error::JobError->throw("submit(): A jobtype is required to submit a job."); }
	if ( !defined($jobtypeid) ) {
		my $jt = Helios::JobType->lookup(name => $jobtype);
		if ( defined($jt) ) {
			$jobtypeid = $jt->getJobtypeid();
			$self->setJobtypeid($jobtypeid);			
		} else {
			# uh-oh, we have no clue what jobtypeid this is
			Helios::Error::JobError->throw("submit(): Jobtype $jobtype cannot be found in the Helios collective database.");
		}
	}
	
	# we should have all we need to create the job in the job queue now
	eval {
		$id = $self->create(
			arg_string => $argstr,
			jobtype    => $jobtype,
			jobtypeid  => $jobtypeid,
		);
		1;
	} or do {
		my $E = $@;
		Helios::Error::JobError->throw("submit(): $E");
	};
	
	return $id;		
}


=head1 JOB COMPLETION METHODS

=head2 completed()

=cut

sub completed {
	my $self = shift;
	
	my $jh = $self->JobHistoryClass()->new(
			jobid          => $self->getJobid(),
			jobtypeid      => $self->getJobtypeid(),
			args           => $self->getArgString(),
			insert_time    => $self->getInsertTime(),
			priority       => $self->getPriority(),
			uniqkey        => $self->getUniqkey(),
			exitstatus     => 0,			
			run_after      => $self->getRunAfter(),
			locked_until   => $self->getLockedUntil(),
			coalesce       => $self->getCoalesce(),
	);
	my $jhid = $jh->submit();

	if ( defined($self->{_obj}) && $self->{_obj}->isa('Helios::TS::Job')) {
		# OK, we were inflated from a TS job
		# was it pulled from the job queue, or was a lookup done?
		if ( !defined( $self->{_obj}->handle() ) ) {
			# oh crap, it was instantiated from lookup()
			# we'll have to construct a client and job handle
			# and hope it all works when we call completed() on it
			$self->_init_ts_job_handle($self->{_obj});
		}

		$self->{_obj}->completed();
	}

	# fill in new details
	#[] we might need to re-inflate here with the JobHistory object instead
	$self->setExitstatus( $jh->getExitstatus() );
	$self->setCompleteTime( $jh->getCompleteTime() );
	
	# in Helios 3, we'll return the jobhistoryid instead of the exitstatus
	return $jhid;
}


=head2 failed()

=cut

sub failed {
	my $self = shift;
	my $err = shift;
	my $status = @_ ? shift : 1;
	
	my $jh = $self->JobHistoryClass()->new(
			jobid          => $self->getJobid(),
			jobtypeid      => $self->getJobtypeid(),
			args           => $self->getArgString(),
			insert_time    => $self->getInsertTime(),
			priority       => $self->getPriority(),
			uniqkey        => $self->getUniqkey(),
			exitstatus     => $status,			
			run_after      => $self->getRunAfter(),
			locked_until   => $self->getLockedUntil(),
			coalesce       => $self->getCoalesce(),
	);
	my $jhid = $jh->submit();

	if ( defined($self->{_obj}) && $self->{_obj}->isa('Helios::TS::Job')) {
		# OK, we were inflated from a TS job
		# was it pulled from the job queue, or was a lookup done?
		if ( !defined( $self->{_obj}->handle() ) ) {
			# oh crap, it was instantiated from lookup()
			# we'll have to construct a client and job handle
			# and hope it all works when we call completed() on it
			$self->_init_ts_job_handle($self->{_obj});
		}

		$self->{_obj}->failed(substr($err,0,254), $status);
	}

	# fill in new details
	#[] we might need to re-inflate here with the JobHistory object instead
	$self->setExitstatus( $jh->getExitstatus() );
	$self->setCompleteTime( $jh->getCompleteTime() );
	
	# in Helios 3, we'll return the jobhistoryid instead of the exitstatus
	return $jhid;
}


=head2 failed_no_retry()

=cut

sub failed_no_retry {
	my $self = shift;
	my $err = shift;
	my $status = @_ ? shift : 1;
	
	my $jh = $self->JobHistoryClass()->new(
			jobid          => $self->getJobid(),
			jobtypeid      => $self->getJobtypeid(),
			args           => $self->getArgString(),
			insert_time    => $self->getInsertTime(),
			priority       => $self->getPriority(),
			uniqkey        => $self->getUniqkey(),
			exitstatus     => $status,			
			run_after      => $self->getRunAfter(),
			locked_until   => $self->getLockedUntil(),
			coalesce       => $self->getCoalesce(),
	);
	my $jhid = $jh->submit();

	if ( defined($self->{_obj}) && $self->{_obj}->isa('Helios::TS::Job')) {
		# OK, we were inflated from a TS job
		# was it pulled from the job queue, or was a lookup done?
		if ( !defined( $self->{_obj}->handle() ) ) {
			# oh crap, it was instantiated from lookup()
			# we'll have to construct a client and job handle
			# and hope it all works when we call completed() on it
			$self->_init_ts_job_handle($self->{_obj});
		}

		$self->{_obj}->permanent_failure(substr($err,0,254), $status);
	}

	# fill in new details
	#[] we might need to re-inflate here with the JobHistory object instead
	$self->setExitstatus( $jh->getExitstatus() );
	$self->setCompleteTime( $jh->getCompleteTime() );
	
	# in Helios 3, we'll return the jobhistoryid instead of the exitstatus
	return $jhid;
}


=head2 deferred() 

=cut

sub deferred {
	my $self = shift;

	if (defined($self->{_obj}) && $self->{_obj}->isa('Helios::TS::Job')) {
		$self->{_obj}->declined();
	}

	return 1;
}



sub _init_ts_job_handle {
	my $self = shift;
	my $obj = shift;
	
	# so this job object was inflated from a Helios::TS::Job
	# BUT NOT BY Helios::TS.
	# This means the TheSchwartz::JobHandle object necessary for
	# completed(), failed(), and failed_permanent() is not present
	# we'll initialize a JobHandle here (which also means we'll have
	# to initialize a Helios::TS client object) so the Helios::TS::Job's
	# job completion methods can work

	#[] dynaload these?	
	use TheSchwartz::JobHandle;
	use Helios::TS;
	#[]use TheSchwartz::Worker;	#[] switch this to Helios::TS::Worker when it's ready
	use Helios::TS::Worker;

	my $cf = $self->getConfig();
	my Helios::TS $c = Helios::TS->new(databases => [{ dsn => $cf->{dsn}, user => $cf->{user}, pass => $cf->{password} }]);
#[]		$c->can_do('TheSchwartz::Worker');
#[]		$c->{active_worker_class} = 'TheSchwartz::Worker';
#[]	$obj->{active_worker_class} = 'TheSchwartz::Worker';
	$obj->{active_worker_class} = 'Helios::TS::Worker';
	my $hashdsn = $c->shuffled_databases();
	my TheSchwartz::JobHandle $h = TheSchwartz::JobHandle->new({ dsn_hashed => $hashdsn, jobid => $self->getJobid });
	$h->client($c);
	$obj->handle($h);
	$obj;
}


=head1 OTHER METHODS

=head2 get_job_history()

=cut

sub get_job_history {
	my $self = shift;
	my %params = @_;
	my $jobid = $params{jobid} || $self->getJobid();
	my $config = $self->getConfig();

	my @objs;
	
	eval {
		@objs = $self->JobHistoryClass()->lookup_by_jobid_full(
			jobid => $jobid,
			config => $config,
		);
		
		1;
	} or do {
		my $E = $@;
		Helios::Error::JobError->throw("Helios::Job->get_job_history(): $E");
	};
	
	return @objs;
}


=head2 get_logs()

=cut

sub get_logs {
	my $self = shift;
	my %params = @_;
	my $jobid = $params{jobid} || $self->getJobid();
	my $config = $self->getConfig();

	my @objs;
	
	eval {
		@objs = $self->LogClass()->lookup_by_jobid_full(
			jobid => $jobid,
			config => $config,
		);
		
		1;
	} or do {
		my $E = $@;
		Helios::Error::JobError->throw("Helios::Job->get_logs(): $E");
	};
	
	return @objs;
}


=head2 lock()

=cut

sub lock {
	my $self = shift;
	my %params = @_;
	my $p_locked_until = $params{locked_until};
	my $p_lock_interval = $params{lock_interval} ? $params{lock_interval} : 10;
	my $jobid = $self->getJobid();
	my $drvr;
	my $r;
	my $locked_until;
	my $current;
		
	# we actually need the Helios::TS::Job object here, because we're going to use
	# D::OD to do the operation.
	unless ($self->{_obj} && $jobid) {
		Helios::Error::JobError->throw('Helios::Job->lock(): Helios::Job object was not properly initialized; cannot lock.');
	}
	# if we were inflated from a JobHistory object, we need to throw an error
	# because we cannot lock() already completed jobs
	unless ( $self->{_obj}->isa('Helios::TS::Job') ) {
		Helios::Error::JobError->throw('Helios::Job->lock(): Cannot lock a job that has already been completed.');
	}

	unless ($p_locked_until || $p_lock_interval) { 
		Helios::Error::JobError->throw('Helios::Job->lock(): locked_until or lock_interval is required.'); 
	}

	eval {
		$drvr = $self->getDriver();
		$current = $self->{_obj}->grabbed_until();
		if ($p_locked_until) {
			$locked_until = $p_locked_until;
		} else  {
			$locked_until = time() + $p_lock_interval;
		}
		$self->{_obj}->grabbed_until($locked_until);		
		$r = $drvr->update($self->{_obj}, { grabbed_until => $current });
		
		1;
	} or do {
		my $E = $@;
		Helios::Error::JobError->throw("lock(): $E");
	};

	# throw an error if the number of rows affected isn't 1
	unless ($r == 1) {
		Helios::Error::JobError->throw("Helios::Job->lock(): Job lock attempt unsuccessful.  Another process probably locked it already.");
	}
	# update our grabbed_until with the updated value
	$self->locked_until( $self->{_obj}->grabbed_until() );
	
	# signal the calling routine lock was successful 
	return $r;
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

