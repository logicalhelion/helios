#!/usr/bin/env perl

use strict;
use warnings;
use Helios::Service;
use Helios::Job;

my $service = Helios::Service->new();
$service->prep() or die($service->errstr);
my $config = $service->getConfig();

while (<>) {
	chomp;
	my $jobxml = '<job><params><filename>'.$_.'</filename></params></job>';
	my $job = Helios::Job->new();
	$job->setConfig($config);
	$job->setFuncname('MP3IndexerService');
	$job->setArgXML($jobxml);
	my $jobid = $job->submit();
	
}

=head1 NAME

mp3submit4index.pl - submit jobs to MP3IndexerService for indexing

=head1 SYNOPSIS

 # start the service daemon
 helios.pl MP3IndexerService
 
 # find all the .mp3 files in your file system
 # and submit jobs to Helios to index them
 find / -name "*\.mp3" -print | mp3submit4index.pl

=head1 DESCRIPTION

This is a sample application to demonstrate some of the features of the 
Helios distributed job processing system and how to write services for it.

The mp3submit4index.pl command reads a list of filenames from STDIN and 
submits jobs to Helios for the MP3IndexerService to process.


=head1 SEE ALSO

L<Helios>, L<MP3IndexerService>, L<MP3::Info>

=head1 AUTHOR

Andrew Johnson, E<lt>lajandy at cpan dotorgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Andrew Johnson

This library is free software; you can redistribute it and/or modify
it under the terms of the Artistic License 2.0.

=cut
