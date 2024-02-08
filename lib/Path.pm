package Path;

use 5.38.0;


sub beautify {
	my $path = shift;

  if (not -e $path) {
		return $path;
	}

	my $home = $ENV{"HOME"};
	$path =~ s/\A\Q$home/\~/;

	return $path;
}

1;
