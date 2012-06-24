use 5.008000;
use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# # the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Helios',
    AUTHOR            => 'Andrew Johnson <lajandy at cpan dotorg>',
    ABSTRACT          => 'A system for distributed job processing applications.',
    LICENSE           => 'perl',
    VERSION_FROM      => 'lib/Helios.pm', # finds $VERSION
    PREREQ_PM         => {   Test::Simple           => 0.72,
                             Data::ObjectDriver     => 0.04,
                             DBI                    => 1.52,
                             TheSchwartz            => 1.04,
                             Config::IniFiles       => 2.38,
                             Error                  => 0.17,
                             XML::Simple            => 2.14,
                             Pod::Usage             => 0.01
							},
    EXE_FILES         => [ 'helios.pl', 'helios_job_submit.pl', 'helios_log_clean.pl'],
    INST_SCRIPT       => 'bin',
);


