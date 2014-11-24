use 5.010;
use Data::Dumper;

use Test::More;
unless ( defined($ENV{HELIOS_INI}) ) {
	plan skip_all => '$HELIOS_INI not defined';
} else {
	plan tests => 16;
}

use_ok('Sys::Hostname');
use_ok('Helios');
use_ok('Helios::Log');

my $obj = Helios::Log->new(
		jobid     => 1,
		jobtypeid => 1,
		service   => 'Helios::TestService',
		priority  => 7,
		message   => 'Test message during make test of Helios::Log '.Helios::Log->VERSION,		
);
isa_ok($obj, 'Helios::Log');

my $id = $obj->log_msg();
say Dumper($obj);
say "Logid: $id";
cmp_ok($id, ">", 0, 'submitted log entry');

my $obj2 = Helios::Log->lookup(logid => $id);
isa_ok($obj2, 'Helios::Log');

say Dumper($obj2);

is($obj2->getLogid(), $id, 'check lookup() - id');
is($obj2->getPid(), $$, 'check lookup() - pid');
is($obj2->getHost(), Sys::Hostname::hostname(), 'check lookup - host');
cmp_ok($obj2->getLogTime(), '>', 0, 'check lookup - log_time');
cmp_ok($obj2->getJobid(), '>', 0, 'check lookup() - jobid');
cmp_ok($obj2->getJobtypeid(), '>', 0, 'check lookup() - jobtypeid');
is($obj2->getService(), 'Helios::TestService', 'check lookup() - service');
is($obj2->getPriority(), 7, 'check lookup() - priority');
like($obj2->getMessage(), qr/Test message during make test of Helios/, 'check lookup() - message');

is($obj2->remove(), 1, 'check remove()');

