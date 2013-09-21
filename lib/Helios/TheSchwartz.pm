package Helios::TheSchwartz;

use 5.008;
use strict;
use warnings;
use base qw(TheSchwartz);
use Carp qw( croak );

use constant OK_ERRORS => { map { $_ => 1 } Data::ObjectDriver::Errors->UNIQUE_CONSTRAINT, };

our $VERSION = '2.71_3860';

# FILE CHANGE HISTORY:
# [LH] [2012-07-11]: driver_for(): Changed driver creation to use Helios driver 
# to cache database connections.
# [LH] [2013-09-21]: find_job_for_workers(): Added code to enable job 
# prioritization.


our $T_AFTER_GRAB_SELECT_BEFORE_UPDATE;
our $FIND_JOB_BATCH_SIZE = 50;

sub driver_for {
    my Helios::TheSchwartz $client = shift;
    my($hashdsn) = @_;
    my $driver;
    my $t = time;
    my $cache_duration = $client->{driver_cache_expiration};
    if ($cache_duration && $client->{cached_drivers}{$hashdsn}{create_ts} && $client->{cached_drivers}{$hashdsn}{create_ts} + $cache_duration > $t) {
        $driver = $client->{cached_drivers}{$hashdsn}{driver};
    } else {
        my $db = $client->{databases}{$hashdsn}
            or croak "Ouch, I don't know about a database whose hash is $hashdsn";
        if ($db->{driver}) {
            $driver = $db->{driver};
        } else {
			# [LH] 2012-07-11: Changed driver creation to use Helios driver to 
			# cache database connections.
            $driver = Helios::ObjectDriver::DBI->new(
                        dsn      => $db->{dsn},
                        username => $db->{user},
                        password => $db->{pass},
                      );
        }
        $driver->prefix($db->{prefix}) if exists $db->{prefix};

        if ($cache_duration) {
            $client->{cached_drivers}{$hashdsn}{driver} = $driver;
            $client->{cached_drivers}{$hashdsn}{create_ts} = $t;
        }
    }
    return $driver;
}


sub find_job_for_workers {
    my TheSchwartz $client = shift;
    my($worker_classes) = @_;
    $worker_classes ||= $client->{current_abilities};

    for my $hashdsn ($client->shuffled_databases) {
        ## If the database is dead, skip it.
        next if $client->is_database_dead($hashdsn);

        my $driver = $client->driver_for($hashdsn);
        my $unixtime = $driver->dbd->sql_for_unixtime;

        my @jobs;
        eval {
            ## Search for jobs in this database where:
            ## 1. funcname is in the list of abilities this $client supports;
            ## 2. the job is scheduled to be run (run_after is in the past);
            ## 3. no one else is working on the job (grabbed_until is in
            ##    in the past).
            my @ids = map { $client->funcname_to_id($driver, $hashdsn, $_) }
                      @$worker_classes;

# BEGIN CODE Copyright (C) 2012-3 by Logical Helion, LLC.
			# [LH] [2013-09-21]: Added code to enable job prioritization.
			my $direction = 'descend';
			if ( $client->prioritize eq 'low' ) {
				$direction = 'ascend';
			}
# END CODE Copyright (C) 2012-3 by Logical Helion, LLC.

            @jobs = $driver->search('TheSchwartz::Job' => {
                    funcid        => \@ids,
                    run_after     => \ "<= $unixtime",
                    grabbed_until => \ "<= $unixtime",
                }, { limit => $FIND_JOB_BATCH_SIZE,
                    ( $client->prioritize ? ( sort => 'priority',
                    direction => $direction ) : () )
                }
            );
        };
        if ($@) {
            unless (OK_ERRORS->{ $driver->last_error || 0 }) {
                $client->mark_database_as_dead($hashdsn);
            }
        }

        # for test harness race condition testing
        $T_AFTER_GRAB_SELECT_BEFORE_UPDATE->() if $T_AFTER_GRAB_SELECT_BEFORE_UPDATE;

        my $job = $client->_grab_a_job($hashdsn, @jobs);
        return $job if $job;
    }
}




1;
__END__


=head1 NAME

Helios::TheSchwartz - TheSchwartz subclass for Helios

=head1 DESCRIPTION

Helios::TheSchwartz is a TheSchwartz subclass for Helios.  In conjunction with 
Helios::ObjectDriver::DBI, it implements aggressive DBI connection caching to 
greatly increase efficiency and performance.

The code in this module is lifted from TheSchwartz and modified to 
work with Helios::ObjectDriver::DBI.

=head1 COPYRIGHT, LICENSE & WARRANTY

This software is Copyright 2007, Six Apart Ltd, cpan@sixapart.com. All
rights reserved.

TheSchwartz is free software; you may redistribute it and/or modify it
under the same terms as Perl itself.

TheSchwartz comes with no warranty of any kind.

Portions of this software, where noted, are
Copyright (C) 2012-3 by Logical Helion, LLC.

=cut


