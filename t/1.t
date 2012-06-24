# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Helios.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 18;
BEGIN { 
	use_ok('Helios::Service');
	# check the exception framework
	use_ok('Helios::Error::BaseError');
	use_ok('Helios::Error::Warning');
	use_ok('Helios::Error::Fatal');
	use_ok('Helios::Error::FatalNoRetry');
	use_ok('Helios::Error::DatabaseError');
	use_ok('Helios::Error::InvalidArg');
	use_ok('Helios::Error::LoggingError');
	use_ok('Helios::Error');
	
	# logging
	use_ok('Helios::LogEntry::Levels');
	use_ok('Helios::LogEntry');
	use_ok('Helios::Logger');
	use_ok('Helios::Logger::Internal');

	# collective data classes
	use_ok('Helios::ConfigParam');
	use_ok('Helios::JobHistory');

	# service classes
	use_ok('Helios::Service');
	use_ok('Helios::MetajobBurstService');
	use_ok('Helios::TestService');
	
};

#########################
