package Helios::LogEntry;

use 5.008;
use strict;
use warnings;
use base 'Data::ObjectDriver::BaseObject';

our $VERSION = '2.90_0000';

# [LH] [2014-11-16]: Completely replaced the old 2.x class backed by 
# HELIOS_LOG_TB with this new version backed by HELIOS_LOG_ENTRY_TB.

__PACKAGE__->install_properties({
	columns => [
		'logid',
		'log_time',
		'host',
		'pid',
		'jobid',
		'jobtypeid',
		'service',
		'priority',
		'message',		
	],
	datasource  => 'helios_log_entry_tb',
	primary_key => 'logid',
#[]	driver => Helios::ObjectDriver->getDriver(),	
});

1;
__END__

