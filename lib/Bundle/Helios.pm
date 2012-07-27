package Bundle::Helios;

$VERSION = "2.51_3040";

1;

__END__

=head1 NAME

Bundle::Helios::Generic - install all Helios related modules

=head1 SYNOPSIS

 perl -MCPAN -e 'install Bundle::Helios::Generic'

=head1 CONTENTS

DBI

Data::ObjectDriver    0.04

TheSchwartz           1.04

Error                 0.17

XML::Simple           2.14

Test::Simple          0.72

Pod::Usage

ExtUtils::MakeMaker   6.31

Perl::OSType

Module::Metadata

Module::Build

Config::IniFiles

Helios

=head1 DESCRIPTION

This bundle defines all prerequisite modules for Helios.  Bundles
have special meaning for the CPAN module.  When you install the bundle
module all modules mentioned in L</CONTENTS> will be installed
instead.

=head1 SEE ALSO

L<CPAN/Bundles>
