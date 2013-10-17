use 5.008000;
use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# # the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Helios',
    AUTHOR            => 'Andrew Johnson <lajandy at cpan dotorg>',
    ABSTRACT          => 'A system for distributed job processing applications.',
    (ExtUtils::MakeMaker->VERSION >= 6.3002 ? (LICENSE => 'perl') : () ),
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
    EXE_FILES         => [ 'helios.pl', 'helios_job_submit.pl', 'helios_log_clean.pl',
                           'helios_jobtype_add.pl', 'helios_config_get.pl',
                           'helios_config_set.pl', 'helios_config_unset.pl',
                           'helios_config_import.pl',
                         ],
    INST_SCRIPT       => 'bin',
    (ExtUtils::MakeMaker->VERSION >= 6.46 ? 
    	(META_MERGE   => {
    						'meta-spec' => { version => 1.4 },
                            resources => {
                                homepage   => 'http://helios.logicalhelion.org',
                                bugtracker => 'https://rt.cpan.org/Public/Dist/Display.html?Name=Helios',
                                repository => 'git://github.com/logicalhelion/helios.git',
                            },
                         },    	
    	) 
    	: ()
    ),

);


# CHANGE HISTORY
# [2011-12-15]: Updated ABSTRACT wording.  Updated PREREQ_PM list to simplify 
# installation, especially on RHEL 5.  Removed unnecessary XML::* dependencies.
# [LH] [2013-09-01]: Added META_MERGE section to specify GitHub repo and 
# website URL info.
# [LH] [2013-09-13]: Changed META_MERGE and LICENSE sections to be added only 
# if the loaded ExtUtils::MakeMaker version supports them.  Corrected 
# {repository} section of META_MERGE=>{resources} and added explicit meta-spec 
# version.
# [LH] [2013-10-16]: Removed old LICENSE line.  Added helios_config_* and 
# helios_jobtype_add.pl to EXE_FILES.

