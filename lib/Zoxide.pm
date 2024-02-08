package Zoxide;

use 5.38.0;
use feature 'defer';
use open qw( :std :encoding(UTF-8) );

sub list_dirs {
	my @paths = `zoxide query -l`;
	chomp @paths;

	return @paths;
}

1;
