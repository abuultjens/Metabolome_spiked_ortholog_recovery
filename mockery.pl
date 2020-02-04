#!/usr/bin/env perl
use strict;

sub msg { print STDERR "@_\n"; }
sub wrn { msg("WARNING:", @_); }
sub err { msg("ERROR:", @_); exit(-1); }
sub tsv { join("\t", @_)."\n"; }
sub isprob { my $x=shift; return $x >= 0 and $x <= 1; }

my(@Options, $debug, $seed, $num, $genes, $spike, $numpos, $core, $noise);
setOptions();

# check for errors
$spike > 1 or err("--spike > 1");
$num > 2 or err("--num > 1");
$numpos >= 0 or err("--numpos >= 0");
$numpos <= $num or err("--numpos <= --num");
$genes > 1 or err("--genes > 1");
isprob($noise) or err("--noise 0..1");
isprob($core) or err("--core 0..1");;

# set seed if non-zero
if ($seed) {
  msg("Setting random seed to: $seed");
  srand($seed);
}

# col 0 = target, col 1 .. H = orthologs
my @matrix;

my $G = int( $genes / $core );
msg("Total genes = $G");
my $H = int( (1.0-$core) * $G );
msg("Orthlog groups = $H");
my $C = int($core * $H);
msg("Core ortholog groups = $C");

# add header
$matrix[0][0] = 'TARGET';
for my $col (1 .. $H) {
  $matrix[0][$col] = sprintf "MOG%07d", $col;
}
for my $col (1 .. $spike) {
  $matrix[0][ $H + $col ] = sprintf "SPIKE%03d", $col;
}

# fill matrix with 1s
for my $row (1 .. $num) {
  print STDERR "\rFilling $row/$num            ";
  for my $col (0 .. $H + $spike) {
    $matrix[$row][$col] = 1; #$col <= $C ? 1 : 0;
  }
}

# fill out the accessory genome with some 0s
for my $row (1 .. $num) {
  print STDERR "\rAccessorizing $row/$num            ";
  for my $col ($C+1 .. $H) {
    $matrix[$row][$col] = 0 if rand() > $core;
  }
}

# set to 0 the unspiked targets and accessory
for my $row ($numpos+1 .. $num) {
  print STDERR "\rSpiking $row/$num            ";
  $matrix[$row][0] = 0;
  for my $col (1 .. $spike) {
    $matrix[$row][$H+$col] = 0;
  }
}


# add noise
for my $row (1 .. $num) {
  print STDERR "\rNoisificating $row/$num            ";
  for my $col (0 .. $H + $spike) {
    if (rand() < $noise) {
      $matrix[$row][$col] = $matrix[$row][$col] ? 0 : 1; # flip bit
    }
  }
}

# print matrix
print STDERR "\nWriting output...\n";
for my $row (@matrix) {
  print tsv(@$row);
}

print STDERR "Done.\n";

#----------------------------------------------------------------------
# Option setting routines

sub setOptions {
  use Getopt::Long;

  @Options = (
    {OPT=>"help",    VAR=>\&usage,             DESC=>"This help"},
    {OPT=>"debug!",  VAR=>\$debug, DEFAULT=>0, DESC=>"Debug info"},
    {OPT=>"seed=i",  VAR=>\$seed, DEFAULT=>42, DESC=>"Random seed (0 = randomize it)"},
    {OPT=>"num=i",  VAR=>\$num, DEFAULT=>10, DESC=>"Number of genomes"},
    {OPT=>"numpos=i",  VAR=>\$numpos, DEFAULT=>3, DESC=>"Number of 'positive' genomes"},
    {OPT=>"genes=i",  VAR=>\$genes, DEFAULT=>3000, DESC=>"Average number of genes per genome"},
    {OPT=>"core=f",  VAR=>\$core, DEFAULT=>0.4, DESC=>"Proportion of core genes: 0..1"},
    {OPT=>"spike=i",  VAR=>\$spike, DEFAULT=>20, DESC=>"Number of 'positive' genes"},
    {OPT=>"noise=f",  VAR=>\$noise, DEFAULT=>0.05, DESC=>"Proportion of wrong binary values: 0..1"},
  );

  #(!@ARGV) && (usage());

  &GetOptions(map {$_->{OPT}, $_->{VAR}} @Options) || usage();

  # Now setup default values.
  foreach (@Options) {
    if (defined($_->{DEFAULT}) && !defined(${$_->{VAR}})) {
      ${$_->{VAR}} = $_->{DEFAULT};
    }
  }
}

sub usage {
  print "Usage: $0 [options]\n";
  foreach (@Options) {
    printf "  --%-13s %s%s.\n",$_->{OPT},$_->{DESC},
           defined($_->{DEFAULT}) ? " (default '$_->{DEFAULT}')" : "";
  }
  exit(1);
}
 
#----------------------------------------------------------------------
