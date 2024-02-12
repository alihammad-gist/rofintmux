package Path;

use 5.20.0;
use warnings;
use autodie;

sub beautify {
  my $path = shift;

  if ( not -e $path ) {
    return $path;
  }

  my $home = $ENV{"HOME"};
  $path =~ s/\A\Q$home/\~/;

  return $path;
}

1;
