#--------------------------------------------------------------------
# Cleaning, indexing, and preparing input files for matlab
# Tokenization and stemming should be performed before using this 
#      script for better performance 
#-------------------------------------------------------------------

use strict;
use warnings;
use FindBin;


die "Usage: perl bin/Preprocess/preprocess.pl input_file output_file language" if (@ARGV != 3);

### 0. set up environment variables
my $home_dir = "$FindBin::Bin";
$home_dir =~ s/\/bin\/Preprocess$//;
if (defined $ENV{'PERL5LIB'}) {
    $ENV{'PERL5LIB'} = "$ENV{PERL5LIB}:$home_dir/lib/perl";
} else {
    $ENV{'PERL5LIB'} = "$home_dir/lib/perl";
}


my $prefix = $ARGV[0];
my $output_file = $ARGV[1];
my $lang = $ARGV[2];

my $cmd;

### clean the words
$cmd = "perl $home_dir/bin/Preprocess/clean.pl  $prefix $prefix.clean";
print "\n[Step 1]: $cmd\n";
`$cmd`;
sleep(1);

if ("$prefix.clean" ne $output_file) {
    `mv $prefix.clean $output_file`;
}
