# This Makefile is for the Helios extension to perl.
#
# It was generated automatically by MakeMaker version
# 6.94 (Revision: 69400) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#       ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker ARGV: ()
#

#   MakeMaker Parameters:

#     ABSTRACT => q[A system for distributed job processing applications.]
#     AUTHOR => [q[Andrew Johnson <lajandy at cpan dotorg>]]
#     BUILD_REQUIRES => {  }
#     CONFIGURE_REQUIRES => {  }
#     EXE_FILES => [q[helios.pl], q[helios_job_submit.pl], q[helios_log_clean.pl], q[helios_jobtype_add], q[helios_config_get], q[helios_config_set], q[helios_config_unset], q[helios_config_import], q[helios_service_status], q[helios_job_info], q[helios_job_status], q[helios_jobtype_info]]
#     INST_SCRIPT => q[bin]
#     LICENSE => q[perl]
#     META_MERGE => { resources=>{ repository=>q[git://github.com/logicalhelion/helios.git], homepage=>q[http://helios.logicalhelion.org], bugtracker=>q[https://rt.cpan.org/Public/Dist/Display.html?Name=Helios] }, meta-spec=>{ version=>q[1.4] } }
#     NAME => q[Helios]
#     PREREQ_PM => { Pod::Usage=>q[0.01], XML::Simple=>q[2.14], Test::Simple=>q[0.72], Config::IniFiles=>q[2.38], Error=>q[0.17], Data::ObjectDriver=>q[0.04], TheSchwartz=>q[1.04], DBI=>q[1.52] }
#     TEST_REQUIRES => {  }
#     VERSION_FROM => q[lib/Helios.pm]

# --- MakeMaker post_initialize section:


# --- MakeMaker const_config section:

# These definitions are from config.sh (via /usr/lib/perl/5.14/Config.pm).
# They may have been overridden via Makefile.PL or on the command line.
AR = ar
CC = cc
CCCDLFLAGS = -fPIC
CCDLFLAGS = -Wl,-E
DLEXT = so
DLSRC = dl_dlopen.xs
EXE_EXT = 
FULL_AR = /usr/bin/ar
LD = cc
LDDLFLAGS = -shared -O2 -g -L/usr/local/lib -fstack-protector
LDFLAGS =  -fstack-protector -L/usr/local/lib
LIBC = 
LIB_EXT = .a
OBJ_EXT = .o
OSNAME = linux
OSVERS = 2.6.42-37-generic
RANLIB = :
SITELIBEXP = /usr/local/share/perl/5.14.2
SITEARCHEXP = /usr/local/lib/perl/5.14.2
SO = so
VENDORARCHEXP = /usr/lib/perl5
VENDORLIBEXP = /usr/share/perl5


# --- MakeMaker constants section:
AR_STATIC_ARGS = cr
DIRFILESEP = /
DFSEP = $(DIRFILESEP)
NAME = Helios
NAME_SYM = Helios
VERSION = 2.82
VERSION_MACRO = VERSION
VERSION_SYM = 2_82
DEFINE_VERSION = -D$(VERSION_MACRO)=\"$(VERSION)\"
XS_VERSION = 2.82
XS_VERSION_MACRO = XS_VERSION
XS_DEFINE_VERSION = -D$(XS_VERSION_MACRO)=\"$(XS_VERSION)\"
INST_ARCHLIB = blib/arch
INST_SCRIPT = bin
INST_BIN = blib/bin
INST_LIB = blib/lib
INST_MAN1DIR = blib/man1
INST_MAN3DIR = blib/man3
MAN1EXT = 1p
MAN3EXT = 3pm
INSTALLDIRS = site
INSTALL_BASE = /home/andrew/perl5
DESTDIR = 
PREFIX = $(INSTALL_BASE)
INSTALLPRIVLIB = $(INSTALL_BASE)/lib/perl5
DESTINSTALLPRIVLIB = $(DESTDIR)$(INSTALLPRIVLIB)
INSTALLSITELIB = $(INSTALL_BASE)/lib/perl5
DESTINSTALLSITELIB = $(DESTDIR)$(INSTALLSITELIB)
INSTALLVENDORLIB = $(INSTALL_BASE)/lib/perl5
DESTINSTALLVENDORLIB = $(DESTDIR)$(INSTALLVENDORLIB)
INSTALLARCHLIB = $(INSTALL_BASE)/lib/perl5/x86_64-linux-gnu-thread-multi
DESTINSTALLARCHLIB = $(DESTDIR)$(INSTALLARCHLIB)
INSTALLSITEARCH = $(INSTALL_BASE)/lib/perl5/x86_64-linux-gnu-thread-multi
DESTINSTALLSITEARCH = $(DESTDIR)$(INSTALLSITEARCH)
INSTALLVENDORARCH = $(INSTALL_BASE)/lib/perl5/x86_64-linux-gnu-thread-multi
DESTINSTALLVENDORARCH = $(DESTDIR)$(INSTALLVENDORARCH)
INSTALLBIN = $(INSTALL_BASE)/bin
DESTINSTALLBIN = $(DESTDIR)$(INSTALLBIN)
INSTALLSITEBIN = $(INSTALL_BASE)/bin
DESTINSTALLSITEBIN = $(DESTDIR)$(INSTALLSITEBIN)
INSTALLVENDORBIN = $(INSTALL_BASE)/bin
DESTINSTALLVENDORBIN = $(DESTDIR)$(INSTALLVENDORBIN)
INSTALLSCRIPT = $(INSTALL_BASE)/bin
DESTINSTALLSCRIPT = $(DESTDIR)$(INSTALLSCRIPT)
INSTALLSITESCRIPT = $(INSTALL_BASE)/bin
DESTINSTALLSITESCRIPT = $(DESTDIR)$(INSTALLSITESCRIPT)
INSTALLVENDORSCRIPT = $(INSTALL_BASE)/bin
DESTINSTALLVENDORSCRIPT = $(DESTDIR)$(INSTALLVENDORSCRIPT)
INSTALLMAN1DIR = $(INSTALL_BASE)/man/man1
DESTINSTALLMAN1DIR = $(DESTDIR)$(INSTALLMAN1DIR)
INSTALLSITEMAN1DIR = $(INSTALL_BASE)/man/man1
DESTINSTALLSITEMAN1DIR = $(DESTDIR)$(INSTALLSITEMAN1DIR)
INSTALLVENDORMAN1DIR = $(INSTALL_BASE)/man/man1
DESTINSTALLVENDORMAN1DIR = $(DESTDIR)$(INSTALLVENDORMAN1DIR)
INSTALLMAN3DIR = $(INSTALL_BASE)/man/man3
DESTINSTALLMAN3DIR = $(DESTDIR)$(INSTALLMAN3DIR)
INSTALLSITEMAN3DIR = $(INSTALL_BASE)/man/man3
DESTINSTALLSITEMAN3DIR = $(DESTDIR)$(INSTALLSITEMAN3DIR)
INSTALLVENDORMAN3DIR = $(INSTALL_BASE)/man/man3
DESTINSTALLVENDORMAN3DIR = $(DESTDIR)$(INSTALLVENDORMAN3DIR)
PERL_LIB = /usr/share/perl/5.14
PERL_ARCHLIB = /usr/lib/perl/5.14
LIBPERL_A = libperl.a
FIRST_MAKEFILE = Makefile
MAKEFILE_OLD = Makefile.old
MAKE_APERL_FILE = Makefile.aperl
PERLMAINCC = $(CC)
PERL_INC = /usr/lib/perl/5.14/CORE
PERL = /usr/bin/perl
FULLPERL = /usr/bin/perl
ABSPERL = $(PERL)
PERLRUN = $(PERL)
FULLPERLRUN = $(FULLPERL)
ABSPERLRUN = $(ABSPERL)
PERLRUNINST = $(PERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
FULLPERLRUNINST = $(FULLPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
ABSPERLRUNINST = $(ABSPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
PERL_CORE = 0
PERM_DIR = 755
PERM_RW = 644
PERM_RWX = 755

MAKEMAKER   = /home/andrew/perl5/lib/perl5/ExtUtils/MakeMaker.pm
MM_VERSION  = 6.94
MM_REVISION = 69400

# FULLEXT = Pathname for extension directory (eg Foo/Bar/Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT. (eg Oracle)
# PARENT_NAME = NAME without BASEEXT and no trailing :: (eg Foo::Bar)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
MAKE = make
FULLEXT = Helios
BASEEXT = Helios
PARENT_NAME = 
DLBASE = $(BASEEXT)
VERSION_FROM = lib/Helios.pm
OBJECT = 
LDFROM = $(OBJECT)
LINKTYPE = dynamic
BOOTDEP = 

# Handy lists of source code files:
XS_FILES = 
C_FILES  = 
O_FILES  = 
H_FILES  = 
MAN1PODS = helios.pl \
	helios_config_get \
	helios_config_import \
	helios_config_set \
	helios_config_unset \
	helios_job_info \
	helios_job_status \
	helios_job_submit.pl \
	helios_jobtype_add \
	helios_jobtype_info \
	helios_log_clean.pl \
	helios_service_status
MAN3PODS = README.pod \
	helios.pl \
	helios_job_submit.pl \
	helios_log_clean.pl \
	lib/Bundle/Helios.pm \
	lib/Helios.pm \
	lib/Helios/Config.pm \
	lib/Helios/Configuration.pod \
	lib/Helios/Error.pm \
	lib/Helios/Error/BaseError.pm \
	lib/Helios/Error/ConfigError.pm \
	lib/Helios/Error/DatabaseError.pm \
	lib/Helios/Error/Fatal.pm \
	lib/Helios/Error/FatalNoRetry.pm \
	lib/Helios/Error/InvalidArg.pm \
	lib/Helios/Error/JobTypeError.pm \
	lib/Helios/Error/LoggingError.pm \
	lib/Helios/Error/ObjectDriverError.pm \
	lib/Helios/Error/Warning.pm \
	lib/Helios/Job.pm \
	lib/Helios/JobType.pm \
	lib/Helios/Logger.pm \
	lib/Helios/Logger/Internal.pm \
	lib/Helios/MetajobBurstService.pm \
	lib/Helios/ObjectDriver.pm \
	lib/Helios/ObjectDriver/DBI.pm \
	lib/Helios/Service.pm \
	lib/Helios/TS.pm \
	lib/Helios/TS/Job.pm \
	lib/Helios/TestService.pm \
	lib/Helios/Tutorial.pod

# Where is the Config information that we are using/depend on
CONFIGDEP = $(PERL_ARCHLIB)$(DFSEP)Config.pm $(PERL_INC)$(DFSEP)config.h

# Where to build things
INST_LIBDIR      = $(INST_LIB)
INST_ARCHLIBDIR  = $(INST_ARCHLIB)

INST_AUTODIR     = $(INST_LIB)/auto/$(FULLEXT)
INST_ARCHAUTODIR = $(INST_ARCHLIB)/auto/$(FULLEXT)

INST_STATIC      = 
INST_DYNAMIC     = 
INST_BOOT        = 

# Extra linker info
EXPORT_LIST        = 
PERL_ARCHIVE       = 
PERL_ARCHIVE_AFTER = 


TO_INST_PM = README.pod \
	helios.pl \
	helios_job_submit.pl \
	helios_log_clean.pl \
	lib/Bundle/Helios.pm \
	lib/Helios.pm \
	lib/Helios/Config.pm \
	lib/Helios/ConfigParam.pm \
	lib/Helios/Configuration.pod \
	lib/Helios/Error.pm \
	lib/Helios/Error/BaseError.pm \
	lib/Helios/Error/ConfigError.pm \
	lib/Helios/Error/DatabaseError.pm \
	lib/Helios/Error/Fatal.pm \
	lib/Helios/Error/FatalNoRetry.pm \
	lib/Helios/Error/InvalidArg.pm \
	lib/Helios/Error/JobTypeError.pm \
	lib/Helios/Error/LoggingError.pm \
	lib/Helios/Error/ObjectDriverError.pm \
	lib/Helios/Error/Warning.pm \
	lib/Helios/Job.pm \
	lib/Helios/JobHistory.pm \
	lib/Helios/JobType.pm \
	lib/Helios/LogEntry.pm \
	lib/Helios/LogEntry/Levels.pm \
	lib/Helios/Logger.pm \
	lib/Helios/Logger/Internal.pm \
	lib/Helios/MetajobBurstService.pm \
	lib/Helios/ObjectDriver.pm \
	lib/Helios/ObjectDriver/DBI.pm \
	lib/Helios/Service.pm \
	lib/Helios/TS.pm \
	lib/Helios/TS/Job.pm \
	lib/Helios/TestService.pm \
	lib/Helios/Tutorial.pod

PM_TO_BLIB = README.pod \
	$(INST_LIB)/README.pod \
	helios.pl \
	$(INST_LIB)/helios.pl \
	helios_job_submit.pl \
	$(INST_LIB)/helios_job_submit.pl \
	helios_log_clean.pl \
	$(INST_LIB)/helios_log_clean.pl \
	lib/Bundle/Helios.pm \
	blib/lib/Bundle/Helios.pm \
	lib/Helios.pm \
	blib/lib/Helios.pm \
	lib/Helios/Config.pm \
	blib/lib/Helios/Config.pm \
	lib/Helios/ConfigParam.pm \
	blib/lib/Helios/ConfigParam.pm \
	lib/Helios/Configuration.pod \
	blib/lib/Helios/Configuration.pod \
	lib/Helios/Error.pm \
	blib/lib/Helios/Error.pm \
	lib/Helios/Error/BaseError.pm \
	blib/lib/Helios/Error/BaseError.pm \
	lib/Helios/Error/ConfigError.pm \
	blib/lib/Helios/Error/ConfigError.pm \
	lib/Helios/Error/DatabaseError.pm \
	blib/lib/Helios/Error/DatabaseError.pm \
	lib/Helios/Error/Fatal.pm \
	blib/lib/Helios/Error/Fatal.pm \
	lib/Helios/Error/FatalNoRetry.pm \
	blib/lib/Helios/Error/FatalNoRetry.pm \
	lib/Helios/Error/InvalidArg.pm \
	blib/lib/Helios/Error/InvalidArg.pm \
	lib/Helios/Error/JobTypeError.pm \
	blib/lib/Helios/Error/JobTypeError.pm \
	lib/Helios/Error/LoggingError.pm \
	blib/lib/Helios/Error/LoggingError.pm \
	lib/Helios/Error/ObjectDriverError.pm \
	blib/lib/Helios/Error/ObjectDriverError.pm \
	lib/Helios/Error/Warning.pm \
	blib/lib/Helios/Error/Warning.pm \
	lib/Helios/Job.pm \
	blib/lib/Helios/Job.pm \
	lib/Helios/JobHistory.pm \
	blib/lib/Helios/JobHistory.pm \
	lib/Helios/JobType.pm \
	blib/lib/Helios/JobType.pm \
	lib/Helios/LogEntry.pm \
	blib/lib/Helios/LogEntry.pm \
	lib/Helios/LogEntry/Levels.pm \
	blib/lib/Helios/LogEntry/Levels.pm \
	lib/Helios/Logger.pm \
	blib/lib/Helios/Logger.pm \
	lib/Helios/Logger/Internal.pm \
	blib/lib/Helios/Logger/Internal.pm \
	lib/Helios/MetajobBurstService.pm \
	blib/lib/Helios/MetajobBurstService.pm \
	lib/Helios/ObjectDriver.pm \
	blib/lib/Helios/ObjectDriver.pm \
	lib/Helios/ObjectDriver/DBI.pm \
	blib/lib/Helios/ObjectDriver/DBI.pm \
	lib/Helios/Service.pm \
	blib/lib/Helios/Service.pm \
	lib/Helios/TS.pm \
	blib/lib/Helios/TS.pm \
	lib/Helios/TS/Job.pm \
	blib/lib/Helios/TS/Job.pm \
	lib/Helios/TestService.pm \
	blib/lib/Helios/TestService.pm \
	lib/Helios/Tutorial.pod \
	blib/lib/Helios/Tutorial.pod


# --- MakeMaker platform_constants section:
MM_Unix_VERSION = 6.94
PERL_MALLOC_DEF = -DPERL_EXTMALLOC_DEF -Dmalloc=Perl_malloc -Dfree=Perl_mfree -Drealloc=Perl_realloc -Dcalloc=Perl_calloc


# --- MakeMaker tool_autosplit section:
# Usage: $(AUTOSPLITFILE) FileToSplit AutoDirToSplitInto
AUTOSPLITFILE = $(ABSPERLRUN)  -e 'use AutoSplit;  autosplit($$$$ARGV[0], $$$$ARGV[1], 0, 1, 1)' --



# --- MakeMaker tool_xsubpp section:


# --- MakeMaker tools_other section:
SHELL = /bin/sh
CHMOD = chmod
CP = cp
MV = mv
NOOP = $(TRUE)
NOECHO = @
RM_F = rm -f
RM_RF = rm -rf
TEST_F = test -f
TOUCH = touch
UMASK_NULL = umask 0
DEV_NULL = > /dev/null 2>&1
MKPATH = $(ABSPERLRUN) -MExtUtils::Command -e 'mkpath' --
EQUALIZE_TIMESTAMP = $(ABSPERLRUN) -MExtUtils::Command -e 'eqtime' --
FALSE = false
TRUE = true
ECHO = echo
ECHO_N = echo -n
UNINST = 0
VERBINST = 0
MOD_INSTALL = $(ABSPERLRUN) -MExtUtils::Install -e 'install([ from_to => {@ARGV}, verbose => '\''$(VERBINST)'\'', uninstall_shadows => '\''$(UNINST)'\'', dir_mode => '\''$(PERM_DIR)'\'' ]);' --
DOC_INSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'perllocal_install' --
UNINSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'uninstall' --
WARN_IF_OLD_PACKLIST = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'warn_if_old_packlist' --
MACROSTART = 
MACROEND = 
USEMAKEFILE = -f
FIXIN = $(ABSPERLRUN) -MExtUtils::MY -e 'MY->fixin(shift)' --
CP_NONEMPTY = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'cp_nonempty' --


# --- MakeMaker makemakerdflt section:
makemakerdflt : all
	$(NOECHO) $(NOOP)


# --- MakeMaker dist section:
TAR = tar
TARFLAGS = cvf
ZIP = zip
ZIPFLAGS = -r
COMPRESS = gzip --best
SUFFIX = .gz
SHAR = shar
PREOP = $(NOECHO) $(NOOP)
POSTOP = $(NOECHO) $(NOOP)
TO_UNIX = $(NOECHO) $(NOOP)
CI = ci -u
RCS_LABEL = rcs -Nv$(VERSION_SYM): -q
DIST_CP = best
DIST_DEFAULT = tardist
DISTNAME = Helios
DISTVNAME = Helios-2.82


# --- MakeMaker macro section:


# --- MakeMaker depend section:


# --- MakeMaker cflags section:


# --- MakeMaker const_loadlibs section:


# --- MakeMaker const_cccmd section:


# --- MakeMaker post_constants section:


# --- MakeMaker pasthru section:

PASTHRU = LIBPERL_A="$(LIBPERL_A)"\
	LINKTYPE="$(LINKTYPE)"\
	PREFIX="$(PREFIX)"\
	INSTALL_BASE="$(INSTALL_BASE)"


# --- MakeMaker special_targets section:
.SUFFIXES : .xs .c .C .cpp .i .s .cxx .cc $(OBJ_EXT)

.PHONY: all config static dynamic test linkext manifest blibdirs clean realclean disttest distdir



# --- MakeMaker c_o section:


# --- MakeMaker xs_c section:


# --- MakeMaker xs_o section:


# --- MakeMaker top_targets section:
all :: pure_all manifypods
	$(NOECHO) $(NOOP)


pure_all :: config pm_to_blib subdirs linkext
	$(NOECHO) $(NOOP)

subdirs :: $(MYEXTLIB)
	$(NOECHO) $(NOOP)

config :: $(FIRST_MAKEFILE) blibdirs
	$(NOECHO) $(NOOP)

help :
	perldoc ExtUtils::MakeMaker


# --- MakeMaker blibdirs section:
blibdirs : $(INST_LIBDIR)$(DFSEP).exists $(INST_ARCHLIB)$(DFSEP).exists $(INST_AUTODIR)$(DFSEP).exists $(INST_ARCHAUTODIR)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists $(INST_SCRIPT)$(DFSEP).exists $(INST_MAN1DIR)$(DFSEP).exists $(INST_MAN3DIR)$(DFSEP).exists
	$(NOECHO) $(NOOP)

# Backwards compat with 6.18 through 6.25
blibdirs.ts : blibdirs
	$(NOECHO) $(NOOP)

$(INST_LIBDIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_LIBDIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_LIBDIR)
	$(NOECHO) $(TOUCH) $(INST_LIBDIR)$(DFSEP).exists

$(INST_ARCHLIB)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHLIB)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHLIB)
	$(NOECHO) $(TOUCH) $(INST_ARCHLIB)$(DFSEP).exists

$(INST_AUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_AUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_AUTODIR)
	$(NOECHO) $(TOUCH) $(INST_AUTODIR)$(DFSEP).exists

$(INST_ARCHAUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHAUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHAUTODIR)
	$(NOECHO) $(TOUCH) $(INST_ARCHAUTODIR)$(DFSEP).exists

$(INST_BIN)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_BIN)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_BIN)
	$(NOECHO) $(TOUCH) $(INST_BIN)$(DFSEP).exists

$(INST_SCRIPT)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_SCRIPT)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_SCRIPT)
	$(NOECHO) $(TOUCH) $(INST_SCRIPT)$(DFSEP).exists

$(INST_MAN1DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN1DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN1DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN1DIR)$(DFSEP).exists

$(INST_MAN3DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN3DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN3DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN3DIR)$(DFSEP).exists



# --- MakeMaker linkext section:

linkext :: $(LINKTYPE)
	$(NOECHO) $(NOOP)


# --- MakeMaker dlsyms section:


# --- MakeMaker dynamic_bs section:

BOOTSTRAP =


# --- MakeMaker dynamic section:

dynamic :: $(FIRST_MAKEFILE) $(BOOTSTRAP) $(INST_DYNAMIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker dynamic_lib section:


# --- MakeMaker static section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make static"
static :: $(FIRST_MAKEFILE) $(INST_STATIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker static_lib section:


# --- MakeMaker manifypods section:

POD2MAN_EXE = $(PERLRUN) "-MExtUtils::Command::MM" -e pod2man "--"
POD2MAN = $(POD2MAN_EXE)


manifypods : pure_all  \
	README.pod \
	helios.pl \
	helios.pl \
	helios_config_get \
	helios_config_import \
	helios_config_set \
	helios_config_unset \
	helios_job_info \
	helios_job_status \
	helios_job_submit.pl \
	helios_job_submit.pl \
	helios_jobtype_add \
	helios_jobtype_info \
	helios_log_clean.pl \
	helios_log_clean.pl \
	helios_service_status \
	lib/Bundle/Helios.pm \
	lib/Helios.pm \
	lib/Helios/Config.pm \
	lib/Helios/Configuration.pod \
	lib/Helios/Error.pm \
	lib/Helios/Error/BaseError.pm \
	lib/Helios/Error/ConfigError.pm \
	lib/Helios/Error/DatabaseError.pm \
	lib/Helios/Error/Fatal.pm \
	lib/Helios/Error/FatalNoRetry.pm \
	lib/Helios/Error/InvalidArg.pm \
	lib/Helios/Error/JobTypeError.pm \
	lib/Helios/Error/LoggingError.pm \
	lib/Helios/Error/ObjectDriverError.pm \
	lib/Helios/Error/Warning.pm \
	lib/Helios/Job.pm \
	lib/Helios/JobType.pm \
	lib/Helios/Logger.pm \
	lib/Helios/Logger/Internal.pm \
	lib/Helios/MetajobBurstService.pm \
	lib/Helios/ObjectDriver.pm \
	lib/Helios/ObjectDriver/DBI.pm \
	lib/Helios/Service.pm \
	lib/Helios/TS.pm \
	lib/Helios/TS/Job.pm \
	lib/Helios/TestService.pm \
	lib/Helios/Tutorial.pod
	$(NOECHO) $(POD2MAN) --section=1 --perm_rw=$(PERM_RW) \
	  helios.pl $(INST_MAN1DIR)/helios.pl.$(MAN1EXT) \
	  helios_config_get $(INST_MAN1DIR)/helios_config_get.$(MAN1EXT) \
	  helios_config_import $(INST_MAN1DIR)/helios_config_import.$(MAN1EXT) \
	  helios_config_set $(INST_MAN1DIR)/helios_config_set.$(MAN1EXT) \
	  helios_config_unset $(INST_MAN1DIR)/helios_config_unset.$(MAN1EXT) \
	  helios_job_info $(INST_MAN1DIR)/helios_job_info.$(MAN1EXT) \
	  helios_job_status $(INST_MAN1DIR)/helios_job_status.$(MAN1EXT) \
	  helios_job_submit.pl $(INST_MAN1DIR)/helios_job_submit.pl.$(MAN1EXT) \
	  helios_jobtype_add $(INST_MAN1DIR)/helios_jobtype_add.$(MAN1EXT) \
	  helios_jobtype_info $(INST_MAN1DIR)/helios_jobtype_info.$(MAN1EXT) \
	  helios_log_clean.pl $(INST_MAN1DIR)/helios_log_clean.pl.$(MAN1EXT) \
	  helios_service_status $(INST_MAN1DIR)/helios_service_status.$(MAN1EXT) 
	$(NOECHO) $(POD2MAN) --section=3 --perm_rw=$(PERM_RW) \
	  README.pod $(INST_MAN3DIR)/README.$(MAN3EXT) \
	  helios.pl $(INST_MAN3DIR)/helios.$(MAN3EXT) \
	  helios_job_submit.pl $(INST_MAN3DIR)/helios_job_submit.$(MAN3EXT) \
	  helios_log_clean.pl $(INST_MAN3DIR)/helios_log_clean.$(MAN3EXT) \
	  lib/Bundle/Helios.pm $(INST_MAN3DIR)/Bundle::Helios.$(MAN3EXT) \
	  lib/Helios.pm $(INST_MAN3DIR)/Helios.$(MAN3EXT) \
	  lib/Helios/Config.pm $(INST_MAN3DIR)/Helios::Config.$(MAN3EXT) \
	  lib/Helios/Configuration.pod $(INST_MAN3DIR)/Helios::Configuration.$(MAN3EXT) \
	  lib/Helios/Error.pm $(INST_MAN3DIR)/Helios::Error.$(MAN3EXT) \
	  lib/Helios/Error/BaseError.pm $(INST_MAN3DIR)/Helios::Error::BaseError.$(MAN3EXT) \
	  lib/Helios/Error/ConfigError.pm $(INST_MAN3DIR)/Helios::Error::ConfigError.$(MAN3EXT) \
	  lib/Helios/Error/DatabaseError.pm $(INST_MAN3DIR)/Helios::Error::DatabaseError.$(MAN3EXT) \
	  lib/Helios/Error/Fatal.pm $(INST_MAN3DIR)/Helios::Error::Fatal.$(MAN3EXT) \
	  lib/Helios/Error/FatalNoRetry.pm $(INST_MAN3DIR)/Helios::Error::FatalNoRetry.$(MAN3EXT) \
	  lib/Helios/Error/InvalidArg.pm $(INST_MAN3DIR)/Helios::Error::InvalidArg.$(MAN3EXT) \
	  lib/Helios/Error/JobTypeError.pm $(INST_MAN3DIR)/Helios::Error::JobTypeError.$(MAN3EXT) \
	  lib/Helios/Error/LoggingError.pm $(INST_MAN3DIR)/Helios::Error::LoggingError.$(MAN3EXT) \
	  lib/Helios/Error/ObjectDriverError.pm $(INST_MAN3DIR)/Helios::Error::ObjectDriverError.$(MAN3EXT) \
	  lib/Helios/Error/Warning.pm $(INST_MAN3DIR)/Helios::Error::Warning.$(MAN3EXT) \
	  lib/Helios/Job.pm $(INST_MAN3DIR)/Helios::Job.$(MAN3EXT) \
	  lib/Helios/JobType.pm $(INST_MAN3DIR)/Helios::JobType.$(MAN3EXT) \
	  lib/Helios/Logger.pm $(INST_MAN3DIR)/Helios::Logger.$(MAN3EXT) \
	  lib/Helios/Logger/Internal.pm $(INST_MAN3DIR)/Helios::Logger::Internal.$(MAN3EXT) \
	  lib/Helios/MetajobBurstService.pm $(INST_MAN3DIR)/Helios::MetajobBurstService.$(MAN3EXT) \
	  lib/Helios/ObjectDriver.pm $(INST_MAN3DIR)/Helios::ObjectDriver.$(MAN3EXT) \
	  lib/Helios/ObjectDriver/DBI.pm $(INST_MAN3DIR)/Helios::ObjectDriver::DBI.$(MAN3EXT) \
	  lib/Helios/Service.pm $(INST_MAN3DIR)/Helios::Service.$(MAN3EXT) \
	  lib/Helios/TS.pm $(INST_MAN3DIR)/Helios::TS.$(MAN3EXT) \
	  lib/Helios/TS/Job.pm $(INST_MAN3DIR)/Helios::TS::Job.$(MAN3EXT) \
	  lib/Helios/TestService.pm $(INST_MAN3DIR)/Helios::TestService.$(MAN3EXT) \
	  lib/Helios/Tutorial.pod $(INST_MAN3DIR)/Helios::Tutorial.$(MAN3EXT) 




# --- MakeMaker processPL section:


# --- MakeMaker installbin section:

EXE_FILES = helios.pl helios_job_submit.pl helios_log_clean.pl helios_jobtype_add helios_config_get helios_config_set helios_config_unset helios_config_import helios_service_status helios_job_info helios_job_status helios_jobtype_info

pure_all :: $(INST_SCRIPT)/helios_jobtype_info $(INST_SCRIPT)/helios_jobtype_add $(INST_SCRIPT)/helios.pl $(INST_SCRIPT)/helios_config_import $(INST_SCRIPT)/helios_config_unset $(INST_SCRIPT)/helios_job_submit.pl $(INST_SCRIPT)/helios_config_set $(INST_SCRIPT)/helios_job_info $(INST_SCRIPT)/helios_job_status $(INST_SCRIPT)/helios_log_clean.pl $(INST_SCRIPT)/helios_config_get $(INST_SCRIPT)/helios_service_status
	$(NOECHO) $(NOOP)

realclean ::
	$(RM_F) \
	  $(INST_SCRIPT)/helios_jobtype_info $(INST_SCRIPT)/helios_jobtype_add \
	  $(INST_SCRIPT)/helios.pl $(INST_SCRIPT)/helios_config_import \
	  $(INST_SCRIPT)/helios_config_unset $(INST_SCRIPT)/helios_job_submit.pl \
	  $(INST_SCRIPT)/helios_config_set $(INST_SCRIPT)/helios_job_info \
	  $(INST_SCRIPT)/helios_job_status $(INST_SCRIPT)/helios_log_clean.pl \
	  $(INST_SCRIPT)/helios_config_get $(INST_SCRIPT)/helios_service_status 

$(INST_SCRIPT)/helios_jobtype_info : helios_jobtype_info $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/helios_jobtype_info
	$(CP) helios_jobtype_info $(INST_SCRIPT)/helios_jobtype_info
	$(FIXIN) $(INST_SCRIPT)/helios_jobtype_info
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/helios_jobtype_info

$(INST_SCRIPT)/helios_jobtype_add : helios_jobtype_add $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/helios_jobtype_add
	$(CP) helios_jobtype_add $(INST_SCRIPT)/helios_jobtype_add
	$(FIXIN) $(INST_SCRIPT)/helios_jobtype_add
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/helios_jobtype_add

$(INST_SCRIPT)/helios.pl : helios.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/helios.pl
	$(CP) helios.pl $(INST_SCRIPT)/helios.pl
	$(FIXIN) $(INST_SCRIPT)/helios.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/helios.pl

$(INST_SCRIPT)/helios_config_import : helios_config_import $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/helios_config_import
	$(CP) helios_config_import $(INST_SCRIPT)/helios_config_import
	$(FIXIN) $(INST_SCRIPT)/helios_config_import
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/helios_config_import

$(INST_SCRIPT)/helios_config_unset : helios_config_unset $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/helios_config_unset
	$(CP) helios_config_unset $(INST_SCRIPT)/helios_config_unset
	$(FIXIN) $(INST_SCRIPT)/helios_config_unset
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/helios_config_unset

$(INST_SCRIPT)/helios_job_submit.pl : helios_job_submit.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/helios_job_submit.pl
	$(CP) helios_job_submit.pl $(INST_SCRIPT)/helios_job_submit.pl
	$(FIXIN) $(INST_SCRIPT)/helios_job_submit.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/helios_job_submit.pl

$(INST_SCRIPT)/helios_config_set : helios_config_set $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/helios_config_set
	$(CP) helios_config_set $(INST_SCRIPT)/helios_config_set
	$(FIXIN) $(INST_SCRIPT)/helios_config_set
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/helios_config_set

$(INST_SCRIPT)/helios_job_info : helios_job_info $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/helios_job_info
	$(CP) helios_job_info $(INST_SCRIPT)/helios_job_info
	$(FIXIN) $(INST_SCRIPT)/helios_job_info
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/helios_job_info

$(INST_SCRIPT)/helios_job_status : helios_job_status $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/helios_job_status
	$(CP) helios_job_status $(INST_SCRIPT)/helios_job_status
	$(FIXIN) $(INST_SCRIPT)/helios_job_status
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/helios_job_status

$(INST_SCRIPT)/helios_log_clean.pl : helios_log_clean.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/helios_log_clean.pl
	$(CP) helios_log_clean.pl $(INST_SCRIPT)/helios_log_clean.pl
	$(FIXIN) $(INST_SCRIPT)/helios_log_clean.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/helios_log_clean.pl

$(INST_SCRIPT)/helios_config_get : helios_config_get $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/helios_config_get
	$(CP) helios_config_get $(INST_SCRIPT)/helios_config_get
	$(FIXIN) $(INST_SCRIPT)/helios_config_get
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/helios_config_get

$(INST_SCRIPT)/helios_service_status : helios_service_status $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/helios_service_status
	$(CP) helios_service_status $(INST_SCRIPT)/helios_service_status
	$(FIXIN) $(INST_SCRIPT)/helios_service_status
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/helios_service_status



# --- MakeMaker subdirs section:

# none

# --- MakeMaker clean_subdirs section:
clean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean :: clean_subdirs
	- $(RM_F) \
	  $(BASEEXT).bso $(BASEEXT).def \
	  $(BASEEXT).exp $(BASEEXT).x \
	  $(BOOTSTRAP) $(INST_ARCHAUTODIR)/extralibs.all \
	  $(INST_ARCHAUTODIR)/extralibs.ld $(MAKE_APERL_FILE) \
	  *$(LIB_EXT) *$(OBJ_EXT) \
	  *perl.core MYMETA.json \
	  MYMETA.yml blibdirs.ts \
	  core core.*perl.*.? \
	  core.[0-9] core.[0-9][0-9] \
	  core.[0-9][0-9][0-9] core.[0-9][0-9][0-9][0-9] \
	  core.[0-9][0-9][0-9][0-9][0-9] lib$(BASEEXT).def \
	  mon.out perl \
	  perl$(EXE_EXT) perl.exe \
	  perlmain.c pm_to_blib \
	  pm_to_blib.ts so_locations \
	  tmon.out 
	- $(RM_RF) \
	  blib 
	  $(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	- $(MV) $(FIRST_MAKEFILE) $(MAKEFILE_OLD) $(DEV_NULL)


# --- MakeMaker realclean_subdirs section:
realclean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker realclean section:
# Delete temporary files (via clean) and also delete dist files
realclean purge ::  clean realclean_subdirs
	- $(RM_F) \
	  $(MAKEFILE_OLD) $(FIRST_MAKEFILE) 
	- $(RM_RF) \
	  $(DISTVNAME) 


# --- MakeMaker metafile section:
metafile : create_distdir
	$(NOECHO) $(ECHO) Generating META.yml
	$(NOECHO) $(ECHO) '---' > META_new.yml
	$(NOECHO) $(ECHO) 'abstract: '\''A system for distributed job processing applications.'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'author:' >> META_new.yml
	$(NOECHO) $(ECHO) '  - '\''Andrew Johnson <lajandy at cpan dotorg>'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'build_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  ExtUtils::MakeMaker: 0' >> META_new.yml
	$(NOECHO) $(ECHO) 'configure_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  ExtUtils::MakeMaker: 0' >> META_new.yml
	$(NOECHO) $(ECHO) 'dynamic_config: 1' >> META_new.yml
	$(NOECHO) $(ECHO) 'generated_by: '\''ExtUtils::MakeMaker version 6.94, CPAN::Meta::Converter version 2.120351'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'license: perl' >> META_new.yml
	$(NOECHO) $(ECHO) 'meta-spec:' >> META_new.yml
	$(NOECHO) $(ECHO) '  url: http://module-build.sourceforge.net/META-spec-v1.4.html' >> META_new.yml
	$(NOECHO) $(ECHO) '  version: 1.4' >> META_new.yml
	$(NOECHO) $(ECHO) 'name: Helios' >> META_new.yml
	$(NOECHO) $(ECHO) 'no_index:' >> META_new.yml
	$(NOECHO) $(ECHO) '  directory:' >> META_new.yml
	$(NOECHO) $(ECHO) '    - t' >> META_new.yml
	$(NOECHO) $(ECHO) '    - inc' >> META_new.yml
	$(NOECHO) $(ECHO) 'requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  Config::IniFiles: 2.38' >> META_new.yml
	$(NOECHO) $(ECHO) '  DBI: 1.52' >> META_new.yml
	$(NOECHO) $(ECHO) '  Data::ObjectDriver: 0.04' >> META_new.yml
	$(NOECHO) $(ECHO) '  Error: 0.17' >> META_new.yml
	$(NOECHO) $(ECHO) '  Pod::Usage: 0.01' >> META_new.yml
	$(NOECHO) $(ECHO) '  Test::Simple: 0.72' >> META_new.yml
	$(NOECHO) $(ECHO) '  TheSchwartz: 1.04' >> META_new.yml
	$(NOECHO) $(ECHO) '  XML::Simple: 2.14' >> META_new.yml
	$(NOECHO) $(ECHO) 'resources:' >> META_new.yml
	$(NOECHO) $(ECHO) '  bugtracker: https://rt.cpan.org/Public/Dist/Display.html?Name=Helios' >> META_new.yml
	$(NOECHO) $(ECHO) '  homepage: http://helios.logicalhelion.org' >> META_new.yml
	$(NOECHO) $(ECHO) '  repository: git://github.com/logicalhelion/helios.git' >> META_new.yml
	$(NOECHO) $(ECHO) 'version: 2.82' >> META_new.yml
	-$(NOECHO) $(MV) META_new.yml $(DISTVNAME)/META.yml
	$(NOECHO) $(ECHO) Generating META.json
	$(NOECHO) $(ECHO) '{' > META_new.json
	$(NOECHO) $(ECHO) '   "abstract" : "A system for distributed job processing applications.",' >> META_new.json
	$(NOECHO) $(ECHO) '   "author" : [' >> META_new.json
	$(NOECHO) $(ECHO) '      "Andrew Johnson <lajandy at cpan dotorg>"' >> META_new.json
	$(NOECHO) $(ECHO) '   ],' >> META_new.json
	$(NOECHO) $(ECHO) '   "dynamic_config" : 1,' >> META_new.json
	$(NOECHO) $(ECHO) '   "generated_by" : "ExtUtils::MakeMaker version 6.94, CPAN::Meta::Converter version 2.120351",' >> META_new.json
	$(NOECHO) $(ECHO) '   "license" : [' >> META_new.json
	$(NOECHO) $(ECHO) '      "perl_5"' >> META_new.json
	$(NOECHO) $(ECHO) '   ],' >> META_new.json
	$(NOECHO) $(ECHO) '   "meta-spec" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "url" : "http://search.cpan.org/perldoc?CPAN::Meta::Spec",' >> META_new.json
	$(NOECHO) $(ECHO) '      "version" : "2"' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "name" : "Helios",' >> META_new.json
	$(NOECHO) $(ECHO) '   "no_index" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "directory" : [' >> META_new.json
	$(NOECHO) $(ECHO) '         "t",' >> META_new.json
	$(NOECHO) $(ECHO) '         "inc"' >> META_new.json
	$(NOECHO) $(ECHO) '      ]' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "prereqs" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "build" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "ExtUtils::MakeMaker" : "0"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "configure" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "ExtUtils::MakeMaker" : "0"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "runtime" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "Config::IniFiles" : "2.38",' >> META_new.json
	$(NOECHO) $(ECHO) '            "DBI" : "1.52",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Data::ObjectDriver" : "0.04",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Error" : "0.17",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Pod::Usage" : "0.01",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Test::Simple" : "0.72",' >> META_new.json
	$(NOECHO) $(ECHO) '            "TheSchwartz" : "1.04",' >> META_new.json
	$(NOECHO) $(ECHO) '            "XML::Simple" : "2.14"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      }' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "release_status" : "stable",' >> META_new.json
	$(NOECHO) $(ECHO) '   "resources" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "bugtracker" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "web" : "https://rt.cpan.org/Public/Dist/Display.html?Name=Helios"' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "homepage" : "http://helios.logicalhelion.org",' >> META_new.json
	$(NOECHO) $(ECHO) '      "repository" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "url" : "git://github.com/logicalhelion/helios.git"' >> META_new.json
	$(NOECHO) $(ECHO) '      }' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "version" : "2.82"' >> META_new.json
	$(NOECHO) $(ECHO) '}' >> META_new.json
	-$(NOECHO) $(MV) META_new.json $(DISTVNAME)/META.json


# --- MakeMaker signature section:
signature :
	cpansign -s


# --- MakeMaker dist_basics section:
distclean :: realclean distcheck
	$(NOECHO) $(NOOP)

distcheck :
	$(PERLRUN) "-MExtUtils::Manifest=fullcheck" -e fullcheck

skipcheck :
	$(PERLRUN) "-MExtUtils::Manifest=skipcheck" -e skipcheck

manifest :
	$(PERLRUN) "-MExtUtils::Manifest=mkmanifest" -e mkmanifest

veryclean : realclean
	$(RM_F) *~ */*~ *.orig */*.orig *.bak */*.bak *.old */*.old



# --- MakeMaker dist_core section:

dist : $(DIST_DEFAULT) $(FIRST_MAKEFILE)
	$(NOECHO) $(ABSPERLRUN) -l -e 'print '\''Warning: Makefile possibly out of date with $(VERSION_FROM)'\''' \
	  -e '    if -e '\''$(VERSION_FROM)'\'' and -M '\''$(VERSION_FROM)'\'' < -M '\''$(FIRST_MAKEFILE)'\'';' --

tardist : $(DISTVNAME).tar$(SUFFIX)
	$(NOECHO) $(NOOP)

uutardist : $(DISTVNAME).tar$(SUFFIX)
	uuencode $(DISTVNAME).tar$(SUFFIX) $(DISTVNAME).tar$(SUFFIX) > $(DISTVNAME).tar$(SUFFIX)_uu
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)_uu'

$(DISTVNAME).tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME).tar $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME).tar
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)'
	$(POSTOP)

zipdist : $(DISTVNAME).zip
	$(NOECHO) $(NOOP)

$(DISTVNAME).zip : distdir
	$(PREOP)
	$(ZIP) $(ZIPFLAGS) $(DISTVNAME).zip $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).zip'
	$(POSTOP)

shdist : distdir
	$(PREOP)
	$(SHAR) $(DISTVNAME) > $(DISTVNAME).shar
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).shar'
	$(POSTOP)


# --- MakeMaker distdir section:
create_distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"

distdir : create_distdir distmeta 
	$(NOECHO) $(NOOP)



# --- MakeMaker dist_test section:
disttest : distdir
	cd $(DISTVNAME) && $(ABSPERLRUN) Makefile.PL 
	cd $(DISTVNAME) && $(MAKE) $(PASTHRU)
	cd $(DISTVNAME) && $(MAKE) test $(PASTHRU)



# --- MakeMaker dist_ci section:

ci :
	$(PERLRUN) "-MExtUtils::Manifest=maniread" \
	  -e "@all = keys %{ maniread() };" \
	  -e "print(qq{Executing $(CI) @all\n}); system(qq{$(CI) @all});" \
	  -e "print(qq{Executing $(RCS_LABEL) ...\n}); system(qq{$(RCS_LABEL) @all});"


# --- MakeMaker distmeta section:
distmeta : create_distdir metafile
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -e q{META.yml};' \
	  -e 'eval { maniadd({q{META.yml} => q{Module YAML meta-data (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add META.yml to MANIFEST: $$$${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -f q{META.json};' \
	  -e 'eval { maniadd({q{META.json} => q{Module JSON meta-data (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add META.json to MANIFEST: $$$${'\''@'\''}\n"' --



# --- MakeMaker distsignature section:
distsignature : create_distdir
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'eval { maniadd({q{SIGNATURE} => q{Public-key signature (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add SIGNATURE to MANIFEST: $$$${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(TOUCH) SIGNATURE
	cd $(DISTVNAME) && cpansign -s



# --- MakeMaker install section:

install :: pure_install doc_install
	$(NOECHO) $(NOOP)

install_perl :: pure_perl_install doc_perl_install
	$(NOECHO) $(NOOP)

install_site :: pure_site_install doc_site_install
	$(NOECHO) $(NOOP)

install_vendor :: pure_vendor_install doc_vendor_install
	$(NOECHO) $(NOOP)

pure_install :: pure_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

doc_install :: doc_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

pure__install : pure_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

doc__install : doc_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_perl_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLARCHLIB)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLPRIVLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLARCHLIB) \
		$(INST_BIN) $(DESTINSTALLBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(SITEARCHEXP)/auto/$(FULLEXT)


pure_site_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLSITEARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLSITELIB) \
		$(INST_ARCHLIB) $(DESTINSTALLSITEARCH) \
		$(INST_BIN) $(DESTINSTALLSITEBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSITESCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLSITEMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLSITEMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(PERL_ARCHLIB)/auto/$(FULLEXT)

pure_vendor_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLVENDORARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLVENDORLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLVENDORARCH) \
		$(INST_BIN) $(DESTINSTALLVENDORBIN) \
		$(INST_SCRIPT) $(DESTINSTALLVENDORSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLVENDORMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLVENDORMAN3DIR)


doc_perl_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLPRIVLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_site_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLSITELIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_vendor_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLVENDORLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod


uninstall :: uninstall_from_$(INSTALLDIRS)dirs
	$(NOECHO) $(NOOP)

uninstall_from_perldirs ::
	$(NOECHO) $(UNINSTALL) $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist

uninstall_from_sitedirs ::
	$(NOECHO) $(UNINSTALL) $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist

uninstall_from_vendordirs ::
	$(NOECHO) $(UNINSTALL) $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist


# --- MakeMaker force section:
# Phony target to force checking subdirectories.
FORCE :
	$(NOECHO) $(NOOP)


# --- MakeMaker perldepend section:


# --- MakeMaker makefile section:
# We take a very conservative approach here, but it's worth it.
# We move Makefile to Makefile.old here to avoid gnu make looping.
$(FIRST_MAKEFILE) : Makefile.PL $(CONFIGDEP)
	$(NOECHO) $(ECHO) "Makefile out-of-date with respect to $?"
	$(NOECHO) $(ECHO) "Cleaning current config before rebuilding Makefile..."
	-$(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	-$(NOECHO) $(MV)   $(FIRST_MAKEFILE) $(MAKEFILE_OLD)
	- $(MAKE) $(USEMAKEFILE) $(MAKEFILE_OLD) clean $(DEV_NULL)
	$(PERLRUN) Makefile.PL 
	$(NOECHO) $(ECHO) "==> Your Makefile has been rebuilt. <=="
	$(NOECHO) $(ECHO) "==> Please rerun the $(MAKE) command.  <=="
	$(FALSE)



# --- MakeMaker staticmake section:

# --- MakeMaker makeaperl section ---
MAP_TARGET    = perl
FULLPERL      = /usr/bin/perl

$(MAP_TARGET) :: static $(MAKE_APERL_FILE)
	$(MAKE) $(USEMAKEFILE) $(MAKE_APERL_FILE) $@

$(MAKE_APERL_FILE) : $(FIRST_MAKEFILE) pm_to_blib
	$(NOECHO) $(ECHO) Writing \"$(MAKE_APERL_FILE)\" for this $(MAP_TARGET)
	$(NOECHO) $(PERLRUNINST) \
		Makefile.PL DIR= \
		MAKEFILE=$(MAKE_APERL_FILE) LINKTYPE=static \
		MAKEAPERL=1 NORECURS=1 CCCDLFLAGS=


# --- MakeMaker test section:

TEST_VERBOSE=0
TEST_TYPE=test_$(LINKTYPE)
TEST_FILE = test.pl
TEST_FILES = t/*.t
TESTDB_SW = -d

testdb :: testdb_$(LINKTYPE)

test :: $(TEST_TYPE) subdirs-test

subdirs-test ::
	$(NOECHO) $(NOOP)


test_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness($(TEST_VERBOSE), '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)

testdb_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) $(TESTDB_SW) "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)

test_ : test_dynamic

test_static :: test_dynamic
testdb_static :: testdb_dynamic


# --- MakeMaker ppd section:
# Creates a PPD (Perl Package Description) for a binary distribution.
ppd :
	$(NOECHO) $(ECHO) '<SOFTPKG NAME="$(DISTNAME)" VERSION="$(VERSION)">' > $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <ABSTRACT>A system for distributed job processing applications.</ABSTRACT>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <AUTHOR>Andrew Johnson &lt;lajandy at cpan dotorg&gt;</AUTHOR>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Config::IniFiles" VERSION="2.38" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="DBI::" VERSION="1.52" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Data::ObjectDriver" VERSION="0.04" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Error::" VERSION="0.17" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Pod::Usage" VERSION="0.01" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Test::Simple" VERSION="0.72" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="TheSchwartz::" VERSION="1.04" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="XML::Simple" VERSION="2.14" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <ARCHITECTURE NAME="x86_64-linux-gnu-thread-multi-5.14" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <CODEBASE HREF="" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    </IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '</SOFTPKG>' >> $(DISTNAME).ppd


# --- MakeMaker pm_to_blib section:

pm_to_blib : $(FIRST_MAKEFILE) $(TO_INST_PM)
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  README.pod $(INST_LIB)/README.pod \
	  helios.pl $(INST_LIB)/helios.pl \
	  helios_job_submit.pl $(INST_LIB)/helios_job_submit.pl \
	  helios_log_clean.pl $(INST_LIB)/helios_log_clean.pl \
	  lib/Bundle/Helios.pm blib/lib/Bundle/Helios.pm \
	  lib/Helios.pm blib/lib/Helios.pm \
	  lib/Helios/Config.pm blib/lib/Helios/Config.pm \
	  lib/Helios/ConfigParam.pm blib/lib/Helios/ConfigParam.pm \
	  lib/Helios/Configuration.pod blib/lib/Helios/Configuration.pod \
	  lib/Helios/Error.pm blib/lib/Helios/Error.pm \
	  lib/Helios/Error/BaseError.pm blib/lib/Helios/Error/BaseError.pm \
	  lib/Helios/Error/ConfigError.pm blib/lib/Helios/Error/ConfigError.pm \
	  lib/Helios/Error/DatabaseError.pm blib/lib/Helios/Error/DatabaseError.pm \
	  lib/Helios/Error/Fatal.pm blib/lib/Helios/Error/Fatal.pm \
	  lib/Helios/Error/FatalNoRetry.pm blib/lib/Helios/Error/FatalNoRetry.pm \
	  lib/Helios/Error/InvalidArg.pm blib/lib/Helios/Error/InvalidArg.pm \
	  lib/Helios/Error/JobTypeError.pm blib/lib/Helios/Error/JobTypeError.pm \
	  lib/Helios/Error/LoggingError.pm blib/lib/Helios/Error/LoggingError.pm \
	  lib/Helios/Error/ObjectDriverError.pm blib/lib/Helios/Error/ObjectDriverError.pm \
	  lib/Helios/Error/Warning.pm blib/lib/Helios/Error/Warning.pm \
	  lib/Helios/Job.pm blib/lib/Helios/Job.pm \
	  lib/Helios/JobHistory.pm blib/lib/Helios/JobHistory.pm \
	  lib/Helios/JobType.pm blib/lib/Helios/JobType.pm \
	  lib/Helios/LogEntry.pm blib/lib/Helios/LogEntry.pm \
	  lib/Helios/LogEntry/Levels.pm blib/lib/Helios/LogEntry/Levels.pm \
	  lib/Helios/Logger.pm blib/lib/Helios/Logger.pm \
	  lib/Helios/Logger/Internal.pm blib/lib/Helios/Logger/Internal.pm \
	  lib/Helios/MetajobBurstService.pm blib/lib/Helios/MetajobBurstService.pm \
	  lib/Helios/ObjectDriver.pm blib/lib/Helios/ObjectDriver.pm \
	  lib/Helios/ObjectDriver/DBI.pm blib/lib/Helios/ObjectDriver/DBI.pm \
	  lib/Helios/Service.pm blib/lib/Helios/Service.pm \
	  lib/Helios/TS.pm blib/lib/Helios/TS.pm \
	  lib/Helios/TS/Job.pm blib/lib/Helios/TS/Job.pm \
	  lib/Helios/TestService.pm blib/lib/Helios/TestService.pm \
	  lib/Helios/Tutorial.pod blib/lib/Helios/Tutorial.pod 
	$(NOECHO) $(TOUCH) pm_to_blib


# --- MakeMaker selfdocument section:


# --- MakeMaker postamble section:


# End.
