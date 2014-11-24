package Helios::JobHistoryEntry;

use 5.008;
use strict;
use warnings;
use base 'Data::ObjectDriver::BaseObject';

our $VERSION = '2.90_0000';

__PACKAGE__->install_properties({
	columns => [
		'jobhistoryid',
		'jobid',
		'jobtypeid',
		'args',
		'insert_time',		
		'run_after',
		'locked_until',
		'priority',		
		'uniqkey',
		'coalesce',
		'complete_time',
		'exitstatus'
	],
	datasource  => 'helios_job_history_entry_tb',
	primary_key => 'jobhistoryid',
#[]	driver => Helios::ObjectDriver->getDriver(),	
});

1;
__END__
