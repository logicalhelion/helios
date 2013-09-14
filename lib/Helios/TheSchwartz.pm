package Helios::TheSchwartz;

use 5.008;
use strict;
use warnings;
use base qw(TheSchwartz);
use Carp qw( croak );

our $VERSION = '2.61';

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

=cut
