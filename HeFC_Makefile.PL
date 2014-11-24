# CHANGE HISTORY
# [LH] [2014-11-16]: Completely replaced the old Helios 2.x Makefile.PL.  This 
# new Makefile.PL is much more flexible and takes the Helios Foundation Classes
# and other new Helios libraries into account.

use 5.008008;
use ExtUtils::MakeMaker;

# Basic Distribution Info
my %eumm_options = (
    NAME         => 'HeFC',
    AUTHOR       => 'Logical Helion, LLC <lhelion at cpan dot org>',
    ABSTRACT     => 'Foundation classes for Helios distributed processing applications.',
    VERSION_FROM => 'lib/Helios.pm',     
);


# Prereq Modules
$eumm_options{PREREQ_PM} = {
	parent             => 0.221,
    Config::IniFiles   => 2.38,
    Data::ObjectDriver => 0.09,
    DBI                => 1.52,
    Exception::Class   => 1.31,
    JSON::Tiny         => 0.49,
    Scalar::Util       => 1.18,
    Test::Simple       => 0.72,
    Time::HiRes        => 1.86,
    TheSchwartz        => 1.07,
};


# Bundled Commands
$eumm_options{EXE_FILES} = [qw(
    helios.pl
    helios_config_get
    helios_config_import
    helios_config_set
    helios_config_unset
    helios_job_info
    helios_job_status
    helios_job_submit
    helios_jobtype_add
    helios_jobtype_info
    helios_log_clean
    helios_service_status
)];
$eumm_options{INST_SCRIPT} = 'bin';


# License
if (ExtUtils::MakeMaker->VERSION >= 6.3002) {
	$eumm_options{LICENSE} = 'perl'
}


# Minimum Perl Version
if ( ExtUtils::MakeMaker->VERSION >= 6.48 ) {
	$eumm_options{MIN_PERL_VERSION} = 5.008008;
}


# CPAN Metadata
if ( ExtUtils::MakeMaker->VERSION >= 6.46) {
    $eumm_options{META_MERGE} = {
        'meta-spec' => { version => 1.4 },
        'resources' => {
            'bugtracker' => 'https://rt.cpan.org/Public/Dist/Display.html?Name=Helios',
            'homepage'   => 'http://helios.logicalhelion.org',
            'repository' => 'git://github.com/logicalhelion/helios.git',
        } 
    }
}


WriteMakefile(%eumm_options);
