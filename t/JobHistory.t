use 5.010;
use Time::HiRes 'time';
use Data::Dumper;

use Test::More;
unless ( defined($ENV{HELIOS_INI}) ) {
	plan skip_all => '$HELIOS_INI not defined';
} else {
	plan tests => 12;
}

use_ok('Helios::JobHistory');

my $obj = Helios::JobHistory->new(
	jobid       => 1,
	jobtypeid   => 1,
	args        => '{ "jobtypeid": 1, "args": { "arg1": "value1"} }',
	insert_time => time(),
	exitstatus  => 1,
);
isa_ok($obj, 'Helios::JobHistory');

my $id = $obj->submit();
say Dumper($obj);
say "Jobhistoryid: $id";
cmp_ok($id, ">", 0, 'submitted job history entry');

my $obj2 = Helios::JobHistory->lookup(jobhistoryid => $id);
isa_ok($obj2, 'Helios::JobHistory');

say Dumper($obj2);

is($obj2->getJobhistoryid(), $id, 'check lookup() - id');
cmp_ok($obj2->getJobid(), '>', 0, 'check lookup() - jobid');
cmp_ok($obj2->getJobtypeid(), '>', 0, 'check lookup() - jobtypeid');
isnt($obj2->getArgs(), undef, 'check lookup() - arg');
is($obj2->getExitstatus(), 1, 'check lookup() - exitstatus');
isnt($obj2->getCompleteTime(), undef, 'check lookup() - complete_time');
isnt($obj2->getInsertTime(), undef, 'check lookup() - insert_time');

is($obj2->remove(), 1, 'check remove()');

