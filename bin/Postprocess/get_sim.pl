#---------------------------------------------------------------------
# get cosine similarity of sentence pairs (maybe an offset is added)
#---------------------------------------------------------------------


use strict;
use warnings;

die "Usage: perl get_sim.pl input_file1 input_file2 output_file cutoff\n" if (@ARGV != 4);

my $input_file1 = $ARGV[0];
my $input_file2 = $ARGV[1];
my $output_file = $ARGV[2];
my $cutoff = $ARGV[3];

my $sim_offset = 0;

open(I, $input_file1) || die "Cannot open $input_file1\n";
open(I2, $input_file2) || die "Cannot open $input_file2\n";
open(O, ">$output_file") || die "Cannot open $output_file\n";

#<I>;
while (my $str = <I>) {
    $str =~ s/\s+$//;
    my @vec1 = split(/\s+/, $str);
    $str = <I2>;
    $str =~ s/\s+$//;
    my @vec2 = split(/\s+/, $str);
    my $sim = &cosine(\@vec1, \@vec2);
    if ($sim < 0 ){
	$sim=0;
    }if ($sim > $cutoff){
	$sim=$cutoff;
    }
    my $old_range=$cutoff;
    my $max=1;
    my $min=0;
    my $new_range= $max-$min;
    $sim = ((($sim)*$new_range)/$old_range) + $min;
    #$sim += $sim_offset;
    print O "$sim\n";
}

close(I);
close(I2);
close(O);

sub cosine() {
    my ($vec1, $vec2) = @_;
    my $sim = 0;
    my $len1 = 0;
    my $len2 = 0;
    for (my $i = 0; $i < @$vec1; $i++) {
	$sim += $vec1->[$i] * $vec2->[$i];
	$len1 += $vec1->[$i] * $vec1->[$i];
	$len2 += $vec2->[$i] * $vec2->[$i];
    }
    return 0 if ($sim == 0);
    $sim /= sqrt($len1);
    $sim /= sqrt($len2);
    return $sim;
}
