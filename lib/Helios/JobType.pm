package Helios::JobType;

use 5.008008;
use strict;
use warnings;
use TheSchwartz::FuncMap;

use Helios::Config;
use Helios::ObjectDriver;
use Helios::Error;
use Helios::Error::JobTypeError;

our $VERSION = '2.90_0000';

use Class::Tiny qw(
	jobtypeid
	name

	_obj      
	debug     
	driver    
	config    
);


sub BUILD {
	my ($self, $params) = @_;

	# if we were given a basic system object, inflate our object from it
	# otherwise, our init() is done
	if ($params->{obj}) {
		return $self->inflate($params->{obj});
	}
}

=head1 NAME

Helios::JobType - Helios Foundation Class to represent Helios jobtypes

=head1 SYNOPSIS

 # use the lookup() class method to retrieve jobtypes 
 # from the Helios collective database
 my $jobtype = Helios::JobType->lookup(name => 'Helios::TestService');
 	--OR--
 my $jobtype = Helios::JobType->lookup(jobtypeid => 1);

 print "Name: ", $jobtype->getName, " Jobtypeid: ", $jobtype->getJobtypeid,"\n";
 
 # use new() and create() to create new jobtypes
 my $newtype = Helios::JobType->new( name => 'NewJobType' );
 $newtype->create();
 print "Created jobtype ",$newtype->getJobtypeid,"\n";

=head1 DESCRIPTION

Objects of the Helios::JobType class represent jobtypes in the Helios job 
processing system.  Every job has a jobtype, which is roughly analogous to the 
queue a job is in.  Usually, a jobtype's name is the same as the Helios service
that will be running the job, in effect creating a single queue for each Helios
service.  In certain advanced configurations, Helios services can be 
configured to service jobs of several jobtypes.

=head1 ACCESSOR METHODS

 set/getName      name of the jobtype in the Helios database
 set/getJobtypeid jobtypeid in the Helios database
 
 set/getConfig    config hash to use
 set/getDriver    Data::ObjectDriver to Helios database

=cut

sub setName {
	$_[0]->name( $_[1] );
}
sub getName {
	$_[0]->name;
}

sub setJobtypeid {
	$_[0]->jobtypeid($_[1]);	
}
sub getJobtypeid {
	$_[0]->jobtypeid;
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
	$self->setDriver($d);
	return $d;
}


=head1 OBJECT INITIALIZATION

=head2 new([name => $jobtypename][, config => $config_hashref][, driver => $driver_obj][, obj => $elemental_obj])

Creates a new Helios::JobType object.  If parameters are passed, calls init() 
with those parameters to initialize the object's values.

=head2 inflate()

If a basic system object is passed to new() using the 'obj' parameter, 
inflate() will be called to expand the basic object into the full Helios
Foundation Class object.

=cut

sub inflate {
	my $self = shift;
	my $obj = shift;
	# we were given an object to inflate from
	$self->_obj($obj);
	$self->name($obj->funcname);
	$self->jobtypeid($obj->funcid);
	$self;
}


=head1 CLASS METHODS

=head2 lookup([name => $name]|[jobtypeid => $jobtypeid])

Given either a jobtype name or jobtypeid, the lookup method will attempt to 
find a jobtype matching that criteria in the collective database and returns a
Helios::JobType object representing that jobtype to the calling routine.  If a
matching jobtype is not found, undef is returned.

THROWS:  Helios::Error::JobTypeError if a problem occurs querying the Helios
database. 

=cut

sub lookup {
	my $self = shift;
	my %params = @_;
	my $jobtypeid = $params{jobtypeid};
	my $name      = $params{name};
	my $config    = $params{config};
	my $debug     = $params{debug} || 0;
	my $drvr;
	my $obj;
	
	# throw an error if we don't have either name or jobtypeid
	unless ($params{jobtypeid} || $params{name}) {
		Helios::Error::JobTypeError->throw('lookup(): Either a jobtypeid or name is required.');
	}

	eval {
		$drvr = Helios::ObjectDriver->getDriver(config => $config);
		if ($jobtypeid) {
			# use $jobtypeid!
			$obj = $drvr->lookup('TheSchwartz::FuncMap' => $jobtypeid);
		} else {
			# use name
			my $itr = $drvr->search('TheSchwartz::FuncMap' => {funcname => $name});
			$obj = $itr->next();
		}
		
		1;
	} or do {
		my $E = $@;
		Helios::Error::JobTypeError->throw('lookup(): '."$E");
	};
	
	if (defined($obj)) {
		# we found it!
		return Helios::JobType->new(
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


=head1 OBJECT METHODS

=head2 create([name => $name])

Given a jobtype name, create() creates a jobtype with that name in the Helios
collective database and returns the new jobtype's jobtypeid.

If the jobtype's name is not specified, the value returned by getName() will be 
used.

THROWS:  Helios::Error::JobTypeError if the JobType creation fails.

=cut

sub create {
	my $self = shift;
	my %params = @_;
	my $name = $params{name} || $self->getName();
	my $config = $params{config} || $self->getConfig();
	my $id;
	my $obj;
	
	unless ($name) {
		Helios::Error::JobTypeError->throw('create(): A jobtype name is required to create a jobtype.');
	}
	
	eval {
		my $drvr = $self->getDriver(config => $config);
		$obj = TheSchwartz::FuncMap->new( funcname => $name);
		$drvr->insert($obj);
		1;
	} or do {
		my $E = $@;
		Helios::Error::JobTypeError->throw("create(): $E");
	};
	# use the new TheSchwartz::FuncMap object to (re)inflate $self
	$self->inflate($obj);
	# the calling routine expects to receive the jobtypeid
	return $self->getJobtypeid;
}


=head2 remove()

The remove() method deletes a jobtype from the Helios collective database.  
It returns 1 if successful and throws a Helios::Error::JobTypeError if the 
removal operation fails.

USE WITH CAUTION.  All Helios jobs, both enqueued and completed, have an
associated jobtype, and removing a jobtype that still has associated jobs in 
the system will have unintended consequences!

THROWS:  Helios::Error::JobTypeError if the removal operation fails.

=cut

sub remove {
	my $self = shift;
	my $jobtypeid = $self->getJobtypeid;
	my $drvr;
	my $r;
	
	# we actually need the FuncMap object here, because we're going to use
	# D::OD to do the delete operation.
	unless ($self->{_obj} && $jobtypeid) {
		Helios::Error::JobTypeError->throw('remove(): Helios::JobType object was not properly initialized; cannot remove.');
	}
	
	eval {
		$drvr = $self->getDriver();
		$drvr->remove($self->{_obj});

		1;
	} or do {
		my $E = $@;
		Helios::Error::JobTypeError->throw("remove(): $E");
	};
	# signal the calling routine remove was successful 
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
