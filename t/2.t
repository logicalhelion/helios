# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Helios.t'

#########################

use Test::More;
unless ( defined($ENV{HELIOS_INI}) ) {
	plan skip_all => '$HELIOS_INI not defined';
} else {
	plan tests => 5;
}


#########################


# let's try to read the INI file and connect to the helios database
# (HELIOS_INI needs to be set for that)

use_ok('Helios::Service');

$worker = new Helios::Service;
isa_ok($worker, 'Helios::Service');

ok( $worker->getConfigFromIni(), 'reading INI');
$params = $worker->getConfig();
ok( defined($params->{dsn}), 'dsn for helios db');

ok( $worker->getConfigFromDb(), 'reading helios db');


