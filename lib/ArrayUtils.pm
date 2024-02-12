package ArrayUtils;

use 5.20.0;
use warnings;
use autodie;

# removes duplicated entries from a sorted array references
# uses merging portion of merge sort algorithm from merge sort
# to achieve 0(N) time complexity.
sub remove_common_among {
  my $la = shift;
  my $lb = shift;

  my ( $lena, $lenb ) = ( scalar @$la, scalar @$lb );
  my $max = $lena + $lenb;

  my @new = ();
  for ( my ( $i, $j, $k ) = ( 0, 0, 0 ) ; $k < $max ; $k++ ) {

    if ( $i < $lena and $j < $lenb ) {

      # both index are in range so we can compare
      if ( $la->[$i] eq $lb->[$j] ) {

        # increment both and move on, ignoring common value
        $i++;
        $j++;
        $k++;
        next;
      }

      if ( $la->[$i] gt $lb->[$j] ) {

        # item in a in greater so increment b to next item
        push( @new, $lb->[$j] );
        $j++;
        next;
      }

      # $la-[$i] < $lb->[$j] therefore increment a
      push( @new, $la->[$i] );
      $i++;
      next;
    }

    if ( $i == $lena and $j == $lenb ) {

      # both lists are exhausted, exit the loop
      last;
    }

    if ( $lena == $i ) {
      push( @new, $lb->[$j] );
      $j++;
      next;
    }

    # lenb == $j
    push( @new, $la->[$i] );
    $i++;
    next;
  }

  return @new;
}

# remove duplicates, leaving one item behind
# expects both arrays to be sorted
sub unique {
  my $last = shift @_;
  my @new  = ($last);

  for (@_) {
    if ( $last ne $_ ) {
      push( @new, $_ );
    }
    $last = $_;
  }

  return @new;
}

1;

