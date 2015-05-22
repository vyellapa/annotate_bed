use strict;
use warnings;


if(!(-e $ARGV[0]))
{
        die "USAGE: perl $0 ROI INPUT_BED\n";
}

open(ROI, "<$ARGV[0]") or die "Can't open file: $!\n";
open(PARSE, "<$ARGV[1]") or die "Can't open file: $!\n";
my %muts=();
my %samples=();
my %hash=();
my $line;
my $s1_count=0;
my $s2_count=0;
my $common=0;
while(<ROI>) {
chomp;
next if($_ =~ m/^Hugo|^#/);
my @temp=split('\t', $_);
my $h_key=join(' ', $temp[0],$temp[1],$temp[2],$temp[3]);
unless ($muts{$h_key}) {$muts{$h_key}=1;}

}
warn "Done loading genes ...\nParsing bed file $ARGV[1]";
while(<PARSE>) {
chomp;
if($_ =~ m/^#/) {print "$_\tGene\n";}
$line=$_;
my @temp=split('\t', $line);
foreach my $s1 (keys(%muts)) {
my @bed=split(' ', $s1);
  if(($temp[0] eq $bed[0]) && ($temp[1] > $bed[1]) && ($temp[2] < $bed[2])) { print "$line\t$bed[3]\n"; }
  elsif(($temp[0] eq $bed[0]) && ($temp[1] < $bed[1]) && ($temp[2] > $bed[1]) && ($temp[2] < $bed[2])) { print "$line\t$bed[3]\n"; }
  elsif(($temp[0] eq $bed[0]) && ($temp[1] > $bed[1]) && ($temp[1] < $bed[2])  && ($temp[2] > $bed[2])) { print "$line\t$bed[3]\n"; }

  }
}

close(ROI);
close(PARSE);
