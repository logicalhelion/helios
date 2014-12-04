package Helios::TS::Worker;

use 5.008;
use strict;
use warnings;
use base 'TheSchwartz::Worker';

our $VERSION = '2.90_0000';

# CODE CHANGE HISTORY:
# [LH] [2014-11-23]: Created Helios::TS::Worker with modified 
# TheSchwartz::Worker->work_safely() to separate Helios::Service from 
# TheSchwartz::Worker and use the new HeFC Helios::Service->work() calling
# signature. 

#[] documentation for work_safely()!


sub work_safely {
    my ($self, $class, $job) = @_;
    my $client = $job->handle->client;
    my $res;

    $job->debug("Working on $class ...");
    $job->set_as_current;
    $client->start_scoreboard;

    eval {
        $res = $class->work(obj => $job);
    };
    my $errstr = $@;

    my $cjob = $client->current_job;
    if ($errstr) {
        $job->debug("Eval failure: $errstr");
        $cjob->failed($@);
    }
    if (! $cjob->was_declined && ! $cjob->did_something) {
        $cjob->failed('Job did not explicitly complete, fail, or get replaced');
    }

    $client->end_scoreboard;

    # FIXME: this return value is kinda useless/undefined.  should we even return anything?  any callers? -brad
    return $res;
}


1;
__END__

=head1 NAME

Helios::TS::Worker - TheSchwartz::Worker subclass for Helios

=head1 DESCRIPTION

Helios::TS::Worker is a TheSchwartz::Worker subclass for Helios.  It helps 
tie Helios::TS job queuing to Helios services based on Helios::Service.

Most of this code was taken from TheSchwartz and modified to fix bugs and add 
features to work better with Helios.  As such, most of the code in this module 
is Six Apart code with certain Logical Helion modifications.

=head1 COPYRIGHT, LICENSE & WARRANTY

This software is Copyright 2007, Six Apart Ltd, cpan@sixapart.com. All
rights reserved.

TheSchwartz is free software; you may redistribute it and/or modify it
under the same terms as Perl itself.

TheSchwartz comes with no warranty of any kind.

Certain portions of this software, where noted, are Copyright (C) 2014 by
Logical Helion, LLC.  These portions are free software; you can redistribute 
them and/or modify them under the same terms as Perl itself, either Perl 
version 5.8.0 or, at your option, any later version of Perl 5 you may have 
available.  These software portions come with no warranty of any kind.

=cut
