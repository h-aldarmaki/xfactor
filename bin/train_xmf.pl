use strict;
use warnings;
use FindBin;

### 0. initialize env variables

my $home_dir = "$FindBin::Bin";
$home_dir =~ s/\/bin$//;
if (defined $ENV{'PERL5LIB'}) {
    $ENV{'PERL5LIB'} = "$ENV{PERL5LIB}:$home_dir/lib/perl";
} else {
    $ENV{'PERL5LIB'} = "$home_dir/lib/perl";
}


my $clean = 1;
my $is_train = 1;

die "Usage:  perl  train.pl  model1_dir model2dir trail_file1 train_dile2  K  lambda  wm  alpha  n_itrs\n" if (@ARGV < 9);

my $model1_dir = $ARGV[0];
my $model2_dir = $ARGV[1];
my $train_file1 = $ARGV[2];
my $train_file2 = $ARGV[3];
my $k = $ARGV[4];
my $lambda = $ARGV[5];
my $wm = $ARGV[6];
my $alpha = $ARGV[7];
my $n_itrs = $ARGV[8];

if ($train_file1 ne "$model1_dir/train.txt") {
    `cp $train_file1 $model1_dir/train.txt`;
}

if ($train_file2 ne "$model2_dir/train.txt") {
    `cp $train_file2 $model2_dir/train.txt`;
}

my $cmd;

### 1. preprocess first language text
$cmd = "perl  $home_dir/bin/Preprocess/clean.pl  $model1_dir/train.txt  $model1_dir/train.clean";
print "[step 1.1]: $cmd\n\n";
my $output = `$cmd`;
print $output;


### 1.2. preprocess second language text
$cmd = "perl  $home_dir/bin/Preprocess/clean.pl  $model2_dir/train.txt  $model2_dir/train.clean";
print "\n[step 1.2]: $cmd\n\n";
$output = `$cmd`;
print $output;

### 2.1. change to matlab format (first language)
$cmd = "perl $home_dir/bin/Preprocess/change_format.pl  $model1_dir  0  $model1_dir/train.clean  $model1_dir/train.ind";
print "\n[step 2.1]: $cmd\n\n";
$output = `$cmd`;
print $output;


### 2.2. change to matlab format (second language)
$cmd = "perl $home_dir/bin/Preprocess/change_format.pl  $model2_dir 1 $model2_dir/train.clean  $model2_dir/train.ind";
print "\n[step 2.2]: $cmd\n\n";
$output = `$cmd`;
print $output;



#run matlab

$cmd = "nice matlab -r \"path(path,'$home_dir/ormf'); train_xWMF('$model1_dir/train.ind', '$model2_dir/train.ind', '$model1_dir/model', '$model2_dir/model', $k, $lambda, $wm, $alpha);exit\"";

print "[step 3]: $cmd\n\n";
print `$cmd`;


