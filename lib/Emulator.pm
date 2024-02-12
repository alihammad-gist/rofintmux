package Emulator;

use 5.20.0;
use warnings;
use autodie;
use File::Basename;
use Rofi;

# sourced from https://metacpan.org/dist/Terminal-Identify/source/lib/Terminal/Identify.pm
my %emulators = (
  "alacritty"              => "Alacritty",
  "altyo"                  => "AltYo",
  "aminal"                 => "Aminal",
  "aterm"                  => "aterm",
  "blackbox"               => "Black Box",
  "black-screen"           => "Black Screen",
  "boxi"                   => "Boxi",
  "cathode"                => "Cathode",
  "commander"              => "Commander One",
  "contour"                => "Contour Terminal",
  "coolterm"               => "CoolTerm",
  "cool-retro-term"        => "Cool Retro Term",
  "cutecom"                => "CuteCom",
  "deepin-terminal"        => "Deepin Terminal",
  "domterm"                => "DomTerm",
  "dterm"                  => "dterm",
  "dtterm"                 => "dtterm",
  "edex-ui"                => "eDEX-UI",
  "eterm"                  => "Eterm",
  "extraterm"              => "Extraterm",
  "fbpad"                  => "Fbpad",
  "fbterm"                 => "Fbterm",
  "finalterm"              => "Final Term",
  "flexterm"               => "Flex Term",
  "foot"                   => "foot",
  "gnome-terminal"         => "GNOME Terminal",
  "gtkterm"                => "GtkTerm",
  "guake"                  => "Guake Terminal",
  "havoc"                  => "Havoc",
  "hterm"                  => "hterm",
  "hyper"                  => "Hyper",
  "iterm"                  => "iTerm",
  "iterm2"                 => "iTerm2",
  "kitty"                  => "kitty",
  "konsole"                => "Konsole",
  "kterm"                  => "kterm",
  "libiterm"               => "libiterm",
  "lilyterm"               => "LilyTerm",
  "lterm"                  => "lterm",
  "lxterminal"             => "LXTerminal",
  "macterm"                => "MacTerm",
  "macwise"                => "MacWise",
  "mate-terminal"          => "MATE-Terminal",
  "minicom"                => "Minicom",
  "mlterm"                 => "mlterm",
  "mlterm-tiny"            => "mlterm-tiny",
  "mrxvt"                  => "mrxvt",
  "netterm"                => "NetTerm",
  "noter"                  => "NoTer",
  "okidk"                  => "OkiDK",
  "pantheon-terminal"      => "Pantheon Terminal",
  "picocom"                => "PicoCom",
  "pterm"                  => "pterm",
  "powershell"             => "PowerShell",
  "powerterm"              => "PowerTerm",
  "putty"                  => "PuTTY",
  "qtterm"                 => "QtTerm",
  "qterminal"              => "QTerminal",
  "realterm"               => "RealTerm",
  "rocket"                 => "Rocket",
  "roxterm"                => "ROXTerm",
  "rxvt"                   => "rxvt",
  "rxvt-unicode"           => "rxvt-unicode",
  "rxvt-unicode-truecolor" => "rxvt-unicode-truecolor",
  "sakura"                 => "Sakura",
  "screen"                 => "SCREEN",
  "shellcraft"             => "ShellCraft",
  "stjerm"                 => "stjerm",
  "stterm"                 => "stterm",
  "tabby"                  => "Tabby",
  "terminal"               => "Terminal",
  "terminalpp"             => "terminalpp",
  "terminator"             => "Terminator",
  "terminix"               => "Terminix",
  "terminology"            => "Terminology",
  "terminus"               => "Terminus",
  "termite"                => "Termite",
  "termit"                 => "Termit",
  "teraterm"               => "Tera Term",
  "tilda"                  => "Tilda",
  "tilix"                  => "Tilix",
  "tinyterm"               => "TinyTERM",
  "treeterm"               => "TreeTerm",
  "tterm"                  => "TTerm",
  "tym"                    => "tym",
  "upterm"                 => "Upterm",
  "urxvt"                  => "urxvt",
  "uxterm"                 => "UXTerm",
  "wazaterm"               => "Wazaterm",
  "wezterm"                => "WezTerm",
  "windterm"               => "WindTerm",
  "wterm"                  => "Wterm",
  "xfce4-terminal"         => "Xfce4 Terminal",
  "xiki"                   => "Xiki",
  "xiterm"                 => "xiterm",
  "xiterm+thai"            => "xiterm+thai",
  "xterm"                  => "XTerm",
  "xvt"                    => "Xvt",
  "yakuake"                => "Yakuake",
  "yat"                    => "YAT",
  "zoc"                    => "ZOC",
  "zterm"                  => "ZTerm"
);

sub get_available_emulators {
  if ( defined $ENV{"TERMINAL"} ) {
    my $bin   = $ENV{"TERMINAL"};
    my $label = $emulators{ basename($bin) } // $bin;

    return ( $bin => $label );
  }

  my %execs = ();
  foreach my $key ( keys %emulators ) {
    if ( -x "/usr/bin/$key" ) {
      $execs{$key} = $emulators{$key};
    }
  }

  return %execs;
}

sub is_emulator {
  my $name = shift;

  if ( defined $emulators{$name} ) {
    return 1;
  }

  return 0;
}

sub run {
  my $bin = shift;
  my $cmd = shift;

  for ($bin) {
    /gnome-terminal/ && do { `$bin -- bash -c "$cmd"`; last };
    /kitty/          && do { `$bin sh -c "$cmd"`;      last };
    /alacritty/      && do { `$bin -e $cmd`;           last };
    /tilda/          && do { `$bin -c "$cmd"`;         last };

    `$bin -e 'bash -c "$cmd"'`;
  }

}

sub new_client {
  my $session = shift;

  my %emulators = get_available_emulators();

  my @bins   = keys %emulators;
  my @labels = ();

  foreach my $i ( keys @bins ) {
    $labels[$i] = $emulators{ $bins[$i] };
  }

  my $choice_id =
    Rofi::dmenu( "Please select an emulator", @labels );

  if ( defined $choice_id ) {
    say "chosen $bins[$choice_id]";
    run( $bins[$choice_id], "tmux attach -t $session" );
  }
}

1;
