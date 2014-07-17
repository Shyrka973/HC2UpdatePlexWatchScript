#!/usr/bin/perl

my $version = '0.1';
my $author_info = <<EOF;
##########################################
#   Author: Andre Duclos
#  Created: 2014-07-12
# Modified: 2014-07-12
#
#  Version: $version
#    https://github.com/shyrka/Update
##########################################
EOF

use strict;
use Getopt::Long;
use Pod::Usage;
use LWP::UserAgent;
use JSON;

#use LWP::Debug qw(+);
#use Data::Dumper;

my %options = ();
GetOptions(\%options,
           'file=s',
           'version',
           'help|?'
    ) or pod2usage(2);

pod2usage(-verbose => 2) if (exists($options{'help'}));

if ($options{version}) {
    print "\n\tVersion: $version\n\n";
    print "$author_info\n";
    exit;
}

if (defined($options{'file'})) {
	my $filename = $options{'file'};

	open FILE, "<", $options{'file'} or die "Impossible d'ouvrir le fichier: $filename\n$!";
	
	my $data = <FILE>;
	
	close (FILE);

	my $json = JSON->new();
	
	my $decoded = $json->decode($data);
	
	#print Dumper($decoded);
	
	my $cmd = "/opt/plexWatch/HCxUpdateVar.pl";
	$cmd .= " --host 192.168.0.100";
	$cmd .= " -user admin --passwd xxxxx";
	$cmd .= " --sceneid 14";
	$cmd .= " --var TVWatch" . $decoded->{'user'};
	$cmd .= " --value " . $decoded->{'ntype'};
	#print $cmd . "\n";
	system($cmd);
}

__DATA__

__END__

=head1 NOM

Update.pl - Met a jour la variable globale TVWath{'user'} avec {'ntype'}

=head1 SYNOPSIS


Update.pl [options]

  Options:

	--file=...          fichier contenant les données json
