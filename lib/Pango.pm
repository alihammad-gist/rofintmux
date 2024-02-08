package Pango;

use 5.38.0;
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
    return qq{${\(icon(" ", COLOR_INIT))}  $item};
  }

  return "   $item";

}

sub render_dir {
  my $path = shift;

  my $icon = icon( " ", COLOR_FOLDER );
  if ( dirname($path) eq "/" ) {
    return "$icon  $path";
  }

  my $dir = dim( dirname($path) . "/" );
  return "$icon  $dir${\(basename $path)}";
}

sub render_hidden_session {
  my $name = shift;
  my $dir  = shift;

  my $icon = icon( " ", COLOR_HIDDEN );
  return "$icon $name ${\(dim($dir))}";
}

sub render_attached_session {
  my $name = shift;
  my $dir  = shift;

  my $icon = icon( " ", COLOR_ATTACHED );
  return "$icon $name ${\(dim($dir))}";
}

sub dim {
  my $text = shift;
  return qq{<span foreground="${\(COLOR_DIM)}">$text</span>};
}

sub icon {
  my ( $icon, $color ) = @_;

  return qq{<span size="large" foreground="$color">$icon</span>};
}

1;

