package Helios::Config;

use 5.008;
use strict;
use warnings;
use File::Spec;
use Sys::Hostname;

use Config::IniFiles;  	

use Helios::ObjectDriver::DBI;
use Helios::ConfigParam;
use Helios::Error::ConfigError;

our $VERSION = '2.52_4310';

=head1 NAME

Helios::Config - base class for Helios configuration system

=head1 SYNOPSIS

 # to determine a service's config based on
 # a particular conf file and host
 use Helios::Config;
 Helios::Config->init(
     CONF_FILE => '/path/to/helios.ini',
     HOSTNAME  => 'host',
     SERVICE   => 'ServiceName'
 );
 my $config = Helios::Config->parseConfig();
 
 # if $HELIOS_INI env var is set and current host is used
 use Helios::Config;
 Helios::Config->init(SERVICE => 'ServiceName');
 my $config = Helios::Config->parseConfig();
 
 # same as above; parseConfig() will automatically call init()
 use Helios::Config;
 my $config = Helios::Config->parseConfig(SERVICE => 'ServiceName');
 
 # you can also use accessor methods; for example, with Helios::TestService:
 use Helios::Config;
 Helios::Config->setServiceName('Helios::TestService');
 Helios::Config->init();
 my $config = Helios::Config->parseConfig();

 # catch config errors with eval {}
 # Try::Tiny works too 
 use Helios::Config;
 my $config;
 eval {
 	Helios::Config->init(SERVICE => 'Helios::TestService');
 	$config = Helios::Config->parseConfig();
 } or do {
 	my $E = $@;
 	if ( $E->isa('Helios::Error::ConfigError') ) {
 		print "Helios configuration error: $E\n";
 	} else {
 		print "I do not know what happened, but it was bad.\n";
 	}
 };
 

=head1 DESCRIPTION

Helios::Config is the standard class for determining configuration information 
in the Helios framework.  It handles parsing configuration information from the 
Helios configuration file, and determining the configuration for services from 
information in the Helios collective database.  Helios::Config also acts as a 
base class for the Helios configuration API; services can define specialized
Helios::Config subclasses to extend configuration subsystem functionality.

Normally, the developer of Helios services does not need to interact with 
Helios::Config directly.  Helios normally handles all configuration 
transparently during service setup before a service's run() method is called.  
A Helios service need only call its getConfig() method to retrieve a hashref of 
its configuration parameters.  Only those wanting to retrieve a Helios service 
configuration outside of the service (e.g. to write an external utility as 
an adjunct to a Helios service) or those with advanced configuration needs
will need to work with Helios::Config directly.

It should be noted that, like Helios::Logger subclasses, Helios::Config methods
are actually class methods, not instance (object) methods.  If you need to 
implement other methods outside of the methods defined 
below, make sure you implement them as class methods.

=head1 ACCESSOR METHODS

Helios::Config provides 7 set/get accessor pairs to provide access to 
configuration data.  There are 3 categories of accessors:  ones that need to 
be set before configuration parsing is initialized, those that are used during 
configuration parsing, and those that hold the end results of the parsing
procedure (i.e. the actual configuration helios.pl and the Helios service will 
need).

=head2 INITIALIZATION ACCESSORS

These need to be set before configuration parsing is initialized with the 
init() method.  If they are not set, the init() method will try to set them 
from data in the environment.

 set/getConfFile()        path to the Helios conf file 
                          -defaults to $HELIOS_INI env variable
 set/getHostname()        hostname the Helios service is running on
                          -defaults to results of Sys::Hostname::hostname()
 set/getServiceName()     name of the running Helios service
                          -defaults to undefined, which will cause the
                           resulting config to contain the contents of the 
                           helios.ini [global] section only

=head2 CONFIG PARSING ACCESSORS

These methods will be set during the configuration parsing process.  Most 
Helios service developers will not need to be aware of these, but if you are 
developing a specialized Helios::Config subclass, they may be useful.

 set/getConfFileConfig()  the config info parsed from helios.ini
 set/getDbConfig()        the config info parsed from the collective database
 set/getDriver()          Data::ObjectDriver object connected to collective db

=head2 PARSING RESULTS ACCESSORS

This method contains the results of the configuration parsing process.  In 
other words, the actual configuration information for the given Helios service.

 set/getConfig()          the complete config info from both conf file & db

=cut

my $Debug = 0;
my $Errstr;
sub debug  { my $self = shift; @_ ? $Debug = shift : $Debug;   }
sub errstr { my $self = shift; @_ ? $Errstr = shift : $Errstr; }

my $ConfFile = $ENV{HELIOS_INI};
sub setConfFile {
	my $var = $_[0]."::ConfFile";
	no strict 'refs';
	$$var = $_[1]; 
}
sub getConfFile { 
    my $var = $_[0]."::ConfFile";
    no strict 'refs';
    return $$var;	
}

my $Hostname = hostname();
sub setHostname {
	my $var = $_[0]."::Hostname";
	no strict 'refs';
	$$var = $_[1]; 
}
sub getHostname { 
    my $var = $_[0]."::Hostname";
    no strict 'refs';
    return $$var;	
}


my $ServiceName;
sub setServiceName {
	my $var = $_[0]."::ServiceName";
	no strict 'refs';
	$$var = $_[1]; 
}
sub getServiceName { 
    my $var = $_[0]."::ServiceName";
    no strict 'refs';
    return $$var;	
}


my $Driver;
sub setDriver {
	my $var = $_[0]."::Driver";
	no strict 'refs';
	$$var = $_[1]; 
}
sub getDriver { 
	initDriver(@_);
}
sub initDriver {
	my $self = shift;
	my $config = $self->getConfFileConfig();
	if ($self->debug) { print __PACKAGE__.'->initDriver('.$config->{dsn}.','.$config->{user}.")\n"; }
	my $driver = Helios::ObjectDriver::DBI->new(
	    dsn      => $config->{dsn},
	    username => $config->{user},
	    password => $config->{password}
	);	
	if ($self->debug) { print __PACKAGE__.'->initDriver() DRIVER: ',$driver,"\n"; }
	$self->setDriver($driver);
	return $driver;	
}


my $Config;
sub setConfig {
	my $var = $_[0]."::Config";
	no strict 'refs';
	$$var = $_[1]; 
}
sub getConfig { 
    my $var = $_[0]."::Config";
    no strict 'refs';
    return $$var;	
}

my $ConfFileConfig;
sub setConfFileConfig {
	my $var = $_[0]."::ConfFileConfig";
	no strict 'refs';
	$$var = $_[1]; 
}
sub getConfFileConfig { 
    my $var = $_[0]."::ConfFileConfig";
    no strict 'refs';
    return $$var;	
}

my $DbConfig;
sub setDbConfig {
	my $var = $_[0]."::DbConfig";
	no strict 'refs';
	$$var = $_[1]; 
}
sub getDbConfig { 
    my $var = $_[0]."::DbConfig";
    no strict 'refs';
    return $$var;	
}



=head1 CONFIGURATION INITIALIZATION METHODS

=head2 init([%params])

Prepares Helios::Config to parse the configuration for a particular Helios 
service.  Accepts initialization information as a hash of parameters; if a 
parameter is not given, init() will attempt to default to values based on 
information from the environment.

The init() method accepts 4 arguments:

 CONF_FILE  path to the helios.ini file (default: $HELIOS_INI env var)
 HOSTNAME   hostname (default: current hostname from Sys::Hostname::hostname())
 DEBUG      enable/disable debug mode (default: disabled)
 SERVICE    name of the Helios service to determine configuration for 
            (default: none)

For example, to initialize Helios::Config to parse the configuration 
information from /etc/helios/helios.ini for the Helios::TestService service 
on the host named host1.hosting.com, one would call init() as:

 Helios::Config->init(
 	CONF_FILE => '/etc/helios/helios.ini',
 	HOSTNAME  => 'host1.hosting.com',
 	SERVICE   => 'Helios::TestService'
 );

Normally the host and config file are specified by the operating system and the
$HELIOS_INI environment variable, so a more typical init() call in a properly 
set up Helios collective would only specify the service:

 Helios::Config->init(SERVICE => 'Helios::TestService');

=cut

sub init {
	my $self = shift;
	my %params = @_;
	if ( defined($params{CONF_FILE}) ) { $self->setConfFile($params{CONF_FILE}); }
	if ( defined($params{SERVICE})   ) { $self->setServiceName($params{SERVICE}); }
	if ( defined($params{HOSTNAME})  ) { $self->setHostname($params{HOSTNAME}); }
	if ( defined($params{DEBUG})     ) { $self->debug($params{DEBUG}); }
	
	# pull hostname from the environment if not already set
	unless ( $self->getHostname() ) {
		$self->setHostname( hostname() );
	}
	# again, pull conf file from environment if not already set
	if ( !defined($self->getConfFile()) && defined($ENV{HELIOS_INI}) ) {
		$self->setConfFile( $ENV{HELIOS_INI} );
	}
	
	# init() clears previous config
	$self->setConfFileConfig(undef);
	$self->setDbConfig(undef);
	$self->setConfig(undef);
	
	return $self;
}


=head1 CONFIGURATION PARSING METHODS

=head2 parseConfig([%params])

Given a set of optional initialization parameters, parseConfig() will parse 
the helios.ini config file and query the Helios collective database for 
configuration information for a particular Helios service, combining the 
information into a single set of configuration information, which is returned 
to the calling routine as a hash reference.

The parseConfig() method controls the actual parsing and derivation of a 
service's configuration.  This process has 4 steps:

=over 4

=item * Initialization (optional)

If parseConfig() was given options, it will call the init() method 
to (re-)initialize the configuration parsing process.  If no options were 
specified, parseConfig() assumes all the necessary options have already been 
set.

=item * Conf file parsing

If the configuration file has not yet been parsed, parseConfig() calls 
parseConfFile() to parse it.  If the conf file information has already been 
parsed, parseConfig() skips this step.  This is to ensure the helios.pl daemon 
and Helios worker processes do not become unstable if the filesystem with the 
config file becomes unmounted.

See the parseConfFile() method entry for more information about this phase of 
configuration parsing.

=item * Conf database parsing

Given the information obtained in the previous step, parseConfig() calls the 
parseConfDb() method to query the Helios collective database for configuration 
information for the specified Helios service.  Unlike the previous step, 
parseConfig() B<always> calls parseConfDb().  This is so the helios.pl daemon 
and Helios worker processes can dynamically update their configuration from the 
database.

See the parseConfDb() method entry for more information about this phase of 
configuration parsing.

=item * Merging configurations

Once the configurations from the conf file and the database have been 
acquired, parseConfig() merges the config hashes together into a single hash of 
configuration parameters for the specified service.  This single config hashref 
is returned to the calling routine.  A cached copy is also made available 
via the getConfig() method.

Configuration parameters for a service specified in the collective 
database override parameters specified in the conf file.

NOTE: Prior to Helios::Config, Helios assembled configuration parameter hashes 
differently.  Originally, both helios.ini and database config parameters were 
reparsed each time a config refresh was requested, and the new parameters were 
merged with the old configuration values.  This caused config values to "stick"
even if they were completely deleted from the database or conf file.  For 
example, deleting a HOLD parameter was not enough to take a service out of hold
mode; the Helios administrator had to set HOLD to 0.  

Helios::Config merges configurations differently.  Though the conf file config 
is only parsed once, each refresh of the database config starts with a new 
hash, and the config merge process starts with a brand new hash as well.  That 
way the config hash returned by parseConfig() contains only the B<current> 
config parameters, leading to a more predictable configuration subsystem.

=back

=cut

sub parseConfig {
	my $self = shift;
	my $conf_file_config;
	my $conf_db_config;

	# if we were passed options,
	# OR we haven't been initialized,
	# go ahead and call init() (with the given options)
	if (@_ || !( $self->getConfFile() && $self->getHostname() ) ) {
		$self = $self->init(@_);
	}
	
	# only parse conf file once
	if ( $self->getConfFileConfig() ) {
		$conf_file_config = $self->getConfFileConfig();
	} else {
		$conf_file_config = $self->parseConfFile();
	}
	
	# conf db always gets reparsed
	$conf_db_config = $self->parseConfDb();

	# merge configs	
	# deref conf file hashref so db conf 
	# doesn't leak into file conf when merged
	my %conf = %{$self->getConfFileConfig()};
	while ( my ($key, $value) = each %$conf_db_config ) {
		$conf{$key} = $value;
	}
	$self->setConfig(\%conf);
	return \%conf;
}


=head2 parseConfFile([$conf_file, $service_name])

Given an optional conf file and an optional service name, parseConfFile() 
parses the conf file and returns the resulting hashref to the calling routine.  
It also makes the hashref available via the getConfFileConfig() accessor.  
If either the conf file or the service is not specified, the values from the 
getConfFile() and/or getServiceName accessor(s) are used.  The conf file 
location is set by init() to the value of the $HELIOS_INI environment variable 
unless otherwise specified.

The default Helios configuration file is the common .ini file format, where
section headings are denoted by brackets ([]).  Lines not starting with [ are 
considered parameters belonging to the last declared section.  Lines starting 
with # or ; are considered comments and are ignored.  See L<Config::IniFiles> 
(the default underlying file parser) for more format details.  

Helios requires at least one section, [global], in the conf file, which should 
contain at least 3 parameters:

 dsn       DBI datasource name of the Helios collective database
 user      the user to use to access the Helios collective db
 password  the password to use to access the Helios collective db

Without these, the helios.pl daemon will be unable to connect to the collective 
database and will fail to start.

You may also specify other configuration parameters in the [global] section.  
Options set in the [global] section will appear in the configuration parameters 
of all services using that conf file.  This can be useful if you need multiple 
services on a host to share a configuration (e.g. you want to configure all 
services on a host to log messages to a syslogd facility using 
HeliosX::Logger::Syslog).

In addition to [global], you can create other sections as well.  If a section 
name matches the service name specified, the configuration parameters in that 
section will be included in the config hash returned to the calling routine.  
You can use this feature to set defaults for a service, or to set sensitive 
parameters (e.g. passwords) that you do not want to be changable from the 
Helios::Panoptes web admin console.

For example, a Helios conf file that configures the Helios collective db and 
sets some config parameters for the Helios::TestService service would look 
something like:

 [global]
 dsn=dbi:mysql:host=dbhost;db=helios_db
 user=helios_user
 password=xyz123
 
 [Helios::TestService]
 MAX_WORKERS=1
 loggers=HeliosX::Logger::Syslog
 syslog_facility=user
 syslog_options=pid

=cut

sub parseConfFile {
	my $self = shift;
	my $conf_file    = @_ ? shift : $self->getConfFile();
	my $service_name = @_ ? shift : $self->getServiceName();
	my $conf;
	
	unless ($conf_file)    { Helios::Error::ConfigError->throw("No conf file specified"); }
	unless (-r $conf_file) { Helios::Error::ConfigError->throw("Cannot read conf file $conf_file"); }
	
	my $cif = Config::IniFiles->new( -file => $conf_file );
	unless ( defined($cif) ) { Helios::Error::ConfigError->throw("Invalid config file; check configuration"); }

	# global must exist 
	if ($cif->SectionExists("global") ) {
		foreach ( $cif->Parameters("global") ) {
			$conf->{$_} = $cif->val("global", $_);
		}
	} 

	# if there's a section specifically for this service class, read it too
	# (it will effectively override the global section, BTW)
	if ( $cif->SectionExists( $service_name ) ) {
		foreach ( $cif->Parameters($service_name) ) {
			$conf->{$_} = $cif->val($service_name, $_);
		}
	}

	$self->setConfFileConfig($conf);

	return $conf;
}


=head2 parseConfDb([$service_name, $hostname])

The parseConfDb() method queries the Helios collective database for 
configuration parameters matching the specified service name and hostname and 
returns a hashref with those parameters to the calling routine.  If the service 
name and hostname are not specified, the values returned from the 
getServiceName() and getHostname() accessors are used.  The getHostname() value 
is normally set by init() to the value returned by Sys::Hostname::hostname() 
unless otherwise specified.

The default parseConfDb() queries the HELIOS_PARAMS_TB table in the Helios 
collective database.  Two separate queries are done:

=over 4

=item *

Config params matching the service name and a host of '*'.  Config params 
with a '*' host apply to all instances of the service in the entire 
collective.

=item *

Config params matching the service name and the current hostname.  Config 
params with a specific hostname apply only to instances of that service on 
that particular host.  These are useful for HOLDing or HALTing services only on 
one host, or working with differences between hosts (e.g. a host with 4 cores 
and 16GB of RAM can support a higher MAX_WORKERS value than a dual core system 
with 2GB of memory).

=back

The results of these two queries are merged, and the resulting hashref returned 
to the calling routine.  Config parameters for a specific host override config 
params for all ('*') hosts.

Configuration parameters in the Helios collective database can be set using 
the Helios::Panoptes web admin console or using your database's standard SQL
commands.

=cut

sub parseConfDb {
	my $self = shift;
	my $service_name = @_ ? shift : $self->getServiceName();
	my $hostname     = @_ ? shift : $self->getHostname();
	my $conf_all_hosts = {};
	my $conf_this_host = {};
	my $conf = {};
	my @dbparams;

	my $driver = $self->getDriver();
	@dbparams = $driver->search( 'Helios::ConfigParam' => { worker_class => $service_name, host => '*'} );
	foreach (@dbparams) {
		if ($self->debug) { print $_->param(),'=>',$_->value(),"\n"; }
		$conf_all_hosts->{$_->param()} = $_->value();
	}
	@dbparams = $driver->search( 'Helios::ConfigParam' => { worker_class => $service_name, host => $hostname} );
	foreach (@dbparams) {
		if ($self->debug) { print $_->param(), '=>', $_->value(), "\n"; }
		$conf_this_host->{ $_->param() } = $_->value();
	}

	$conf = $conf_all_hosts;
	while ( my ($key, $value) = each %$conf_this_host) {
		$conf->{$key} = $value;
	}
	$self->setDbConfig($conf);
	return $conf;		
}


1;
__END__


=head1 EXTENDING HELIOS::CONFIG

Helios service developers with more advanced configuration needs than 
Helios::Config supplies can extend the Helios::Config class to override 
its methods and/or provide methods of their own.  There are 2 steps required 
to take advantage of this functionality:

=over 4

=item * Extend Helios::Config

In defining a Helios::Config subclass, there are 2 important methods that 
drive the configuration parsing process:  init() and parseConfig().  Without 
these methods, the Helios framework will be unable to use the new config 
class.  

=item * Set the ConfigClass() method in your Helios service 

Just like JobClass() with jobs, ConfigClass() defines an alternate class to use 
to perform configuration parsing for your particular Helios service.  For 
example:

 package MyService;
 
 use 5.010;
 use strict;
 use warnings;
 use parent 'Helios::Service';
 
 use MyConfig;
 
 sub ConfigClass { 'MyConfig'; }

 sub run {
 	my $self = shift;
 	my $job = shift;
 	my $config = $self->getConfig();
 	my $args = $self->getJobArgs($job);
 	
 	....
 }
 
 1;


=back

=head1 HELIOS CONFIGURATION PARAMETERS

The Helios system defines a large number of configuration parameters.  Some of 
these affect the operation of the helios.pl daemon, others worker processes, 
and some can affect both.  Aside from these reserved parameter names, the 
configuration parameters your Helios service uses are largely up to you.  

Helios configuration parameters that affect worker process launching and 
management are usually in ALL CAPS.  This helps set them apart from other 
application-level parameters.

=head2 helios.pl

=head3 Collective database configuration parameters

These are the most important parameters in helios.ini.  They must be declared 
in the [global] section.  Without them, helios.pl will be unable to connect to 
the collective database and will fail to start.

=head4 dsn

 dsn=dbi:Oracle:SHARDEV

The dsn parameter is the DBI datasource name of the Helios collective database.

=head4 user

 user=scott

The user parameter is the user to use when connecting to the Helios 
collective database.

=head4 password

 password=tiger

The password parameter is the password to use when connecting to the Helios
collective database.

=head4 options

 options=private_option=>'string',private_option2=>'another string'

The options parameter is used when special DBI options are needed when 
connecting to the Helios collective database.  Normally, this parameter should 
not be necessary but is made available for users who may need to specify 
special parameters in their database connections anyway.

=head3 Other parameters

=head4 pid_path

 pid_path=/home/helios/run

Sets the path where helios.pl daemon will write its PID files.  This should be 
an absolute path to a directory writable by the Helios user (the user the 
helios.pl daemon will run as).  Each helios.pl service daemon will write a PID 
file incorporating the name of the service class it has loaded into this 
directory.  

If this directory does not exist or is not writable by the Helios user, the 
helios.pl daemon will fail to start.

DEFAULT:  /var/run/helios

=head4 registration_interval

The number of seconds to wait before a helios.pl service daemon "checks in" to 
the collective database.  Periodically helios.pl will update a table in the 
Helios collective database for monitoring purposes.  This allows the 
Helios::Panoptes admin console to provide the Collective Admin view, and 
enables Panoptes and other utilities to see if a helios.pl service daemon has 
crashed or has encountered some other type of error.  The default 60 seconds 
should be fine for most purposes, but can be increased to reduce database load 
if necessary.

DEFAULT:  60

=head3 Service-specific Tuning Parameters for helios.pl

There are several parameters useful for tuning the helios.pl service daemon to 
work better with your Helios service.  Helios and the helios.pl daemon default 
to behavior that should work well for processing jobs that last a short amount 
of time (generally 30 seconds or less).  If your jobs consistently last longer
than a minute, or can potentially put a strain on resources like a database or 
a file server, you may wish to adjust the following parameters.

These parameters are not dynamic and should be set in the Helios conf file, 
either in the [global] section or a section matching your service's name.  

=head4 master_launch_interval

 master_launch_interval=5

The master_launch_interval is the amount of time in seconds helios.pl waits 
after launching workers before it attempts to launch workers again.  Normally 
the default of 1 second is fine, but if you need to slow how quickly new worker 
processes are started, you can increase this number.

DEFAULT:  1

=head4 zero_launch_interval

 zero_launch_interval=30

The zero_launch_interval is the amount of time in seconds helios.pl waits 
to launch workers again after the MAX_WORKERS limit has been reached.  Once 
helios.pl launches the MAX_WORKERS number of workers, it will not launch more 
even if there are available jobs in the queue.  If a particular service's jobs 
usually take longer than the default of 10 seconds, or you are using OVERDRIVE 
mode so your worker processes persist until no more jobs available, increasing 
zero_launch_interval may decrease needless database queries.  For most cases, 
the default of 10 seconds should be adequate.

DEFAULT:  10

=head4 zero_sleep_interval

 zero_sleep_interval=20

The zero_sleep_interval is the amount of time between checks for available 
jobs in the job queue when the job queue is empty.  If the helios.pl daemon 
determines there are no available jobs for a service, it sleeps 
zero_sleep_interval seconds and then checks again.  If there are available 
jobs, it starts to launch workers; if there are still none, it sleeps another 
zero_sleep_interval seconds and checks again.  This can cause jobs to "sit" in 
the queue for some seconds before workers are launched to service them.  If 
you do not have enough jobs consistently entering the job queue to keep workers 
running in OVERDRIVE mode, decreasing this number will make helios.pl more 
responsive by launching workers for your jobs sooner (at the expense of extra 
repeated queries of the job queue in the database).  If your jobs can wait in 
the job queue for awhile and you do not have many entering the system, 
increasing this number can reduce the number of needless queries to your 
database.

DEFAULT:  10

=head2 Worker process management

The following configuration parameters affect the management of workers and 
how they run services and process jobs.  These are most typically set in the 
collective database configuration table for each service, thus they are ALL 
CAPS to separate them from your services' own configuration parameters.  Unlike
the parameters in the previous section, these configuration parameters are 
dynamic and can be changed via Helios::Panoptes or SQL commands to your 
collective database.

=head3 HOLD

 HOLD=1

Puts a Helios service in Hold Mode.  All worker processes shut down after 
finishing the current job, and the helios.pl service daemon ignores avaliable 
jobs in the job queue.  Set HOLD to 0 or delete it from the configuration to 
cause Helios to return to Normal Mode.

DEFAULT:  0

=head3 HALT

 HALT=1

Causes a helios.pl service daemon and all its workers to shutdown.  When HALT 
is set for a service, worker processes exit after the current job is finished.  
The helios.pl service daemon waits MAX_WORKER_TTL_WAIT_INTERVAL seconds for 
workers to finish, and sends any remaining workers a SIGKILL signal to 
eliminate any stragglers.  The daemon then removes its registration entry from 
the collective database and exits.

Warning:  BE CAREFUL about setting a HALT for a service for all hosts 
(hostname='*').  This will shutdown all instances of that Helios service in 
the ENTIRE collective, and the only way to restart them is to log into the 
host and start them manually.  If you need to perform maintenance on hosts in 
a production Helios collective, you most likely want to HOLD all instances of 
a service and then HALT each instance individually as needed. 

DEFAULT:  none (the presence of HALT in the config causes a shutdown regardless
of its value)

=head3 MAX_WORKERS

 MAX_WORKERS=10

Along with OVERDRIVE, MAX_WORKERS is the most powerful configuration 
parameter in the Helios framework.  Setting MAX_WORKERS allows a helios.pl 
service daemon to launch multiple workers at a time to service jobs, up to the 
MAX_WORKERS limit.  

Normally, when the helios.pl service daemon sees available jobs in the job 
queue, it starts to launch worker processes to service the jobs.  Normally, 
it launches workers gradually, one at a time, in order to prevent overtaxing 
resources (and to allow the launched workers time to do actually run the 
jobs).  If there are the same or more jobs in the queue as the MAX_WORKERS 
value, helios.pl will "blitz" (launch the maximum amount of workers) to attempt 
to run the jobs in the queue as quickly as possible.  This "blitzing" feature 
is controlled by the WORKER_BLITZ_FACTOR parameter, so if you want want Helios 
to blitz workers B<before> there are that many jobs available in the queue, 
adjust WORKER_BLITZ_FACTOR downward to allow helios.pl to launch more worker 
processes faster.

DEFAULT:  1

=head3 OVERDRIVE

 OVERDRIVE=1

Setting OVERDRIVE causes a worker process to persist in memory continuing to 
run jobs from the job queue until all available jobs for the loaded service 
are exhausted.  Coupled with MAX_WORKERS, allows you to maximize job 
throughput by eliminating repeated process startup procedures and enabling 
caching of database connections and other data structures.

Unless your service is designed to run long-running jobs lazily, you almost 
certainly want to set OVERDRIVE to 1.  It is set to 0 by default because 
indiscriminately running untested, potentially unsafe services can cause 
unexpected, even disasterous behavior.  Make sure your service runs in Normal 
Mode first, then test it in Overdrive Mode throughly before you deploy it.

DEFAULT:  0

=head3 WORKER_BLITZ_FACTOR

 WORKER_BLITZ_FACTOR=0.5

Use WORKER_BLITZ_FACTOR to set the helios.pl service daemon to launch more 
worker processes sooner.  Normally, helios.pl launches one worker process at a 
time unless there are as many jobs as the MAX_WORKERS limit; if there are that 
many jobs in the queue, Helios "blitzes" (launches MAX_WORKERS number of 
workers).  If you want Helios to blitz workers sooner, adjust 
WORKER_BLITZ_FACTOR lower.

The WORKER_BLITZ_FACTOR is a decimal between 0 and 1.  If your service's 
MAX_WORKERS parameter is set to 50 but you want Helios to launch the 
maximum number of workers anytime there are at least 25 available jobs in the 
job queue, you should set WORKER_BLITZ_FACTOR to 0.5.    

DEFAULT:  1 (workers do not blitz until there are at least MAX_WORKERS jobs 
available in the job queue)

=head3 LAZY_CONFIG_UPDATE

 LAZY_CONFIG_UPDATE=1

Use LAZY_CONFIG_UPDATE to increase worker process performance by reducing the 
number of configuration parameter refreshes a worker process performs in 
Overdrive Mode.  In Overdrive Mode, a worker process refreshes the service 
configuration from the collective database just before it calls the service's 
run() method.  With LAZY_CONFIG_UPDATE set to 1, this configuration refresh is 
performed only before every 10th job the worker process runs, reducing 
database queries and thus increasing performance.

NOTE:  The configuration refresh is where worker processes pick up HOLD and 
HALT parameters, so using LAZY_CONFIG_UPDATE will cause worker processes to be 
less responsive when holding jobs or halting the service.  If your service's 
configuration does not change often, you can activate LAZY_CONFIG_UPDATE and 
see if your service experiences a noticable increase. 

DEFAULT:  0

=head3 WORKER_MAX_TTL

 WORKER_MAX_TTL=300

The maximum amount of time in seconds to allow a worker process for a service 
to run.  If a worker process continues to run past this threshold, the 
helios.pl service daemon will assume it has become stuck in some way and will 
send it a SIGKILL signal (9) to kill it (real world situations have shown 
softer signals are unreliable in such situations).  If you set this and find 
worker processes not experiencing problems are being unnecessarily killed, you 
may need to increase the WORKER_MAX_TTL_WAIT_INTERVAL (below).

DEFAULT:  none; workers running in Normal Mode run until their job is complete; 
workers in Overdrive Mode work until no more jobs are available in the job 
queue.

=head3 WORKER_MAX_TTL_WAIT_INTERVAL

Number of seconds a helios.pl service daemon will wait for a worker that has 
reached its WORKER_MAX_TTL to exit.  If a worker process continues running 
past WORKER_MAX_TTL + WORKER_MAX_TTL_WAIT_INTERVAL seconds, helios.pl will 
assume the worker process has hung in some way and will send it a SIGKILL (9) 
signal to kill it.

DEFAULT:  30

=head3 DOWNSHIFT_ON_NONZERO_RUN

 DOWNSHIFT_ON_NONZERO_RUN=1

This to support certain legacy behaviors for Helios services developed before 
Helios 2.40.  You almost certainly do not need to set this.

DEFAULT:  0 (ignore the return value of the service's run() method)

=head2 Logging

=head3 loggers

 loggers=HeliosX::Logger::Syslog,HeliosX::Logger::Log4perl

Specify a comma-separated list of external logging classes to use to log 
information.  Each of the modules listed should implement the Helios::Logger 
interface class.  

Each logger class likely will have its own configuration parameters; see the 
logger's documentation for the appropriate configuration information.

The Helios internal logger (Helios::Logger::Internal) is automatically added 
to this list, unless internal_logger (below) is turned off.

DEFAULT:  None 

=head3 internal_logger

 internal_logger=off

Whether the Helios internal logger (Helios::Logger::Internal) should be used 
to log information.  The internal logger logs information to a table in the 
Helios collective database, and is the log system used by the Helios::Panoptes 
System Log view.  If you want to only use an external logging system such as 
HeliosX::Logger::Log4perl, you can turn off Helios logging completely by 
setting internal_logger to 0 or 'off'.

DEFAULT:  on

=head3 log_priority_threshold

 log_priority_threshold=5

The log level above which the internal logger discards log messages.  
Specifying a log_priority_threshold will cause log messages of a lower priority 
(higher numeric value) to be discarded.  For example, a log_priority_threshold
of 6 (LOG_INFO) will cause log messages with a priority of 7 (LOG_DEBUG) to be 
discarded.

See the Helios::Logger::Internal documentation for more information on log 
thresholds.

DEFAULT:  undefined (all log messages are logged)

=head1 AUTHOR

Andrew Johnson, E<lt>lajandy at cpan dot orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Logical Helion, LLC.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=head1 WARRANTY

This software comes with no warranty of any kind.

=cut

