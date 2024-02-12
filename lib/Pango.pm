package Pango;

use 5.20.0;
use warnings;
use autodie;
use File::Basename;

use constant COLOR_FOLDER   => "#2893E3";
use constant COLOR_ATTACHED => "#02f204";
use constant COLOR_HIDDEN   => "#02f204";
use constant COLOR_INIT     => "#FDF1E7";

use constant COLOR_DIM => "#7a7a7a";

sub markup {
  my $item = shift;

  if ( -d $item ) {
    my $path = Path::beautify($item);
    return render_dir($path);
  }

  if ( Tmux::has_session($item) ) {
    my $dir = Path::beautify( Tmux::session_dir($item) );
    if ( Tmux::session_is_attached($item) ) {
      return render_attached_session( $item, $dir );
    }
    return render_hidden_session( $item, $dir );
  }

  if ( Tmux::is_session_init($item) ) {
    return render_init($item);
  }

  return "   $item";

}

sub render_dir {
  my $path = shift;
  my $name = basename $path;

  my $icon = icon( " ", COLOR_FOLDER );

  my $dir = dim($path);
  return "$icon $name $dir";
}

sub render_hidden_session {
  my $name = shift;
  my $dir  = shift;

  my $icon = icon( " ", COLOR_HIDDEN );
  return "$icon $name ${\(small($dir))}";
}

sub render_attached_session {
  my $name = shift;
  my $dir  = shift;

  my $icon = icon( " ", COLOR_ATTACHED );
  return "$icon $name ${\(small($dir))}";
}

sub render_init {
  my $name = shift;

  my $icon = icon( " ", COLOR_INIT );
  return qq{$icon $name};
}

sub dim {
  my $text = shift;
  return
qq{<span foreground="${\(COLOR_DIM)}" size="smaller">$text</span>};
}

sub small {
  my $text = shift;
  return
qq{<span foreground="${\(COLOR_DIM)}" size="small">$text</span>};
}

sub icon {
  my ( $icon, $color ) = @_;

  return qq{<span size="large" foreground="$color">$icon</span>};
}

1;

