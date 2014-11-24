use 5.010;
use Data::Dumper;

use Test::More;
unless ( defined($ENV{HELIOS_INI}) ) {
	plan skip_all => '$HELIOS_INI not defined';
} else {
	plan tests => 15;
}

use_ok('Helios::Job');
use_ok('Helios::JobHistory');

#[] my $argstring = '<job><params><arg1>value1</arg1></params></job>';
#[] my $argstring2 = '<job><params><arg2>value2</arg2></params></job>';
my $argstring = qq|{ "args":{"arg1":"value1"} }|;
my $argstring2 = qq|{ "args":{"arg2":"value2"} }|;
my $obj = Helios::Job->new(
	jobtype    => 'Helios::TestService',
	arg_string => $argstring,
);
isa_ok($obj, 'Helios::Job');

my $id = $obj->submit();
#t say Dumper($obj);
say "Jobid: $id";
cmp_ok($id, ">", 0, 'submitted job entry');

my $obj2 = Helios::Job->lookup(jobid => $id);
isa_ok($obj2, 'Helios::Job');

#t say Dumper($obj2);

# essential accessors
is($obj2->getJobid(), $id, 'check lookup() - id');
cmp_ok($obj2->getJobtypeid(), '>', 0, 'check lookup() - jobtypeid');
is($obj2->getArgString(), $argstring, 'check lookup() - argstring');
isnt($obj2->getInsertTime(), undef, 'check lookup() - insert_time');

# remove
is($obj2->remove(), 1, 'check remove()');

# ok, submit a new job and test the complete methods
my $j3 = Helios::Job->new(
	jobtype    => 'Helios::TestService',
	arg_string => $argstring2,
);
my $j3id = $j3->submit();
say "j3id is $j3id";
#t say Dumper($j3);

my $j4 = Helios::Job->lookup(jobid => $j3id);
#t say Dumper($j4);
say "NOW TRY TO COMPLETE";
my $j4status = $j4->completed();
cmp_ok($j4status, '>', 0, 'check completed() - jobhistoryid');
is($j4->getExitstatus(), 0, 'check completed() - status');
#t say Dumper($j4);

# now, look up job history for the job we just completed
# if its not there we have a problem
#[] fix this to use Helios::Job's own methods--once we write them :(
say "Looking up history for jobid $j3id...";
my $jh = Helios::JobHistory->lookup(jobid => $j3id);
isa_ok($jh, 'Helios::JobHistory');
is($jh->getExitstatus(), 0, 'check completed() - history exitstatus');
isnt($jh->getCompleteTime(), undef, 'check completed() - history complete time');

# ok, we recorded jobhistory, but we need to delete it, 
# because we're just testing
#t say Dumper($jh);
$jh->remove();
