package Tmux;

use 5.38.0;
use feature 'defer';
use open qw( :std :encoding(UTF-8) );
use Rofi;
use File::Basename;

sub list_sessions {
  my @out = `tmux list-sessions -F "#{session_name}"`;

  # whole lists can be chomped in one go
  chomp @out;

  return @out;
}

sub list_session_inits {
  my @files = glob("~/.tmux/init_tmux/*");

  my @out = ();

  foreach (@files) {
    if ( -x $_ ) {
      push( @out, basename($_) );
    }
  }

  return @out;
}

sub list_dirs {
  my @out = `tmux ls -F "#{session_path}"`;
  chomp @out;

  my @dirs = ();
  foreach (@out) {
    $_ =~ s/\/\z//;
    push( @dirs, $_ );
  }

  return @dirs;
}

sub session_dir {
  my $session = shift;

  my $out =
`tmux ls -F "#{session_path}" -f "#{==:#{session_name},$session"}`;

  chomp $out;

  return $out;
}

sub is_session_init {
  my $session = shift;
  my $home    = $ENV{"HOME"};

  if ( -x "$home/.tmux/init_tmux/$session" ) {
    return 1;
  }

  return 0;
}

sub get_active_client {

  my @clients_output =
    `tmux lsc -F "#{client_activity}:#{client_name}"`;

  my $ret = $? >> 8;
  if ( $ret != 0 or !@clients_output ) {
    return '';
  }

# get the line with newest timestamp (inverting cmp for desc order)
  my $head = ( sort { 0 - ( $a cmp $b ) } @clients_output )[0];

  # split the line and get second field (client_name), remove any
  # whitespaces around the field
  my $last_focused_client = ( split /:/, $head )[1];
  chomp $last_focused_client;
  return $last_focused_client;
}

sub has_session {
  my $session = shift;

  my $out = `tmux has-session -t $session 2>/dev/null`;
  my $ret = $? >> 8;

  return not $ret;
}

sub session_is_attached {
  my $session = shift;

  my $num =
`tmux ls -F "#{session_attached}" -f "#{==:#{session_name},$session}"`;

  chomp $num;

  if ( $num eq '' or $num eq '0' ) {
    return 0;
  }

  return 1;
}

sub activate_session {
  my $name   = shift;
  my $path   = $ENV{'HOME'};
  my $client = get_active_client();

  if ( -d $name ) {
    $path = $name;
    $name = basename($name);
  }

  # create session if it doesn't exist
  if ( not has_session($name) ) {
    `tmux new-session -d -s $name -c $path`;

    my $ret = $? >> 8;
    if ( $ret != 0 ) {
      die "error encountered while creatinga new session";
    }

    # run init if it exists
    my $confirm_msg =
"Found init_tmux file, do you want it executed? <span weight='bold'>%s</span>";
    my $home        = $ENV{'HOME'};
    my $global_init = "$home/.tmux/init_tmux/$name";
    my $local_init  = "$path/.init_tmux";

    if ( -x $local_init ) {
      `$local_init $name $path`
        if Rofi::confirm( sprintf( $confirm_msg, $local_init ) );
    }
    elsif ( -x $global_init ) {
      `$global_init $name $path`
        if Rofi::confirm( sprintf( $confirm_msg, $global_init ) );
    }
  }

  # switch active client to the session
  `tmux switch-client -c $client -t $name`;

}

1;
