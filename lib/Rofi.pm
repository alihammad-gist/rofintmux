package Rofi;

use 5.20.0;
use warnings;
use autodie;
use open qw( :std :encoding(UTF-8) );
use IPC::Open3;

sub dmenu {
  my $prompt     = shift;
  my @workspaces = @_;
  my $pid        = open3(
    my $child_in,
    my $child_out,
    my $child_err,
    qq/rofi -markup-rows -dmenu -format "i" -p "$prompt"/
  );

  for my $item (@workspaces) {
    print $child_in ( $item . "\n" );
  }
  close $child_in;

  my $choice_idx = <$child_out>;

  if ( defined $choice_idx ) {
    chomp $choice_idx;
  }

  return $choice_idx;
}

sub confirm {
  my $question = shift;

  my $answer =
    `echo "Yes|No" | rofi -sep "|" -dmenu -mesg "$question"`;
  chomp $answer;

  if ( $answer eq "Yes" ) {
    return 1;
  }

  return 0;
}

1;
