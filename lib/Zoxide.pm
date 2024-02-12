package Zoxide;

use 5.20.0;
use warnings;
use autodie;
use feature 'defer';
use open qw( :std :encoding(UTF-8) );

sub list_dirs {
  my @paths = `zoxide query -l`;
  chomp @paths;

  return @paths;
}

1;
