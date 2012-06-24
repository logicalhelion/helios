use 5.008000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'MP3IndexerService',
    VERSION_FROM      => 'lib/MP3IndexerService.pm', # finds $VERSION
    PREREQ_PM         => {
    						Helios => 2.31,
    						MP3::Info => 1.24,
    	
    }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/MP3IndexerService.pm', # retrieve abstract from module
       AUTHOR         => 'Andrew Johnson <lajandy at cpan dotorg>') : ()),
);
