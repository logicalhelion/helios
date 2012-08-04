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

our $VERSION = '2.50_3160';

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



=head1 SETUP METHODS

=head2 init()

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


=head1 other

=head2 parseConfig()

=cut

sub parseConfig {
	my $self = shift;
	my $conf_file_config;
	my $conf_db_config;

	# if we were passed options, (re)init with the given options
	if (@_) {
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
	my $conf = $self->getConfFileConfig();
	while ( my ($key, $value) = each %$conf_db_config ) {
		$conf->{$key} = $value;
	}
	$self->setConfig($conf);
	return $conf;
}

=head2 parseConfFile([$conf_file])

=cut

sub parseConfFile {
	my $self = shift;
	my $conf_file = @_ ? shift : $self->getConfFile();
	my $service_name = $self->getServiceName();
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


=head2 parseConfDb()

=cut

sub parseConfDb {
	my $self = shift;
	my $service_name = $self->getServiceName();
	my $hostname = $self->getHostname();
	my $conf_all_hosts ={};
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

