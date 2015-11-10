use strict;
use warnings;
use Irssi;
use IPC::Run 'run';

our $VERSION = '1.0';
our %IRSSI = (
    authors     => 'Michon van Dooren',
    name        => 'tmux-auto-resize',
    description => 'Keeps the adv_windowlist and nicklist panes at certain sizes',
    license     => 'GNU GPL v2 or later',
    url         => 'https://github.com/maienm/dotfiles/irssi/scripts/autorun/tmux-auto-resize.pl',
);

# Script output formatting
Irssi::theme_register(['tmux_auto_resize',
        '{line_start}{hilight '.$IRSSI{'name'}.':} $0']);

### Start internal variable declaration
my $tmux = '/usr/bin/tmux';
sub first_line{ return substr($_[0], 0, index($_[0], "\n")) }
my $tmux_session_window = &first_line(
    qx/$tmux list-windows -F '#{session_name}'/).':'.&first_line(
    qx/$tmux list-panes -F '#{window_index}'/);
my $current_width;
my $current_height;
### End internal variable declaration

### Start external settings handling
Irssi::settings_add_int('tmux_auto_resize', 'tmux_pane_index_windowlist', 1);
Irssi::settings_add_int('tmux_auto_resize', 'tmux_pane_index_nicklist', 2);
Irssi::settings_add_int('tmux_auto_resize', 'tmux_width', 20);

my $tmux_pane_index_windowlist;
my $tmux_pane_index_nicklist;
my $tmux_width;
my $tmux_windowlist_height;

sub load_settings
{
    $tmux_pane_index_windowlist = Irssi::settings_get_int('tmux_pane_index_windowlist');
    $tmux_pane_index_nicklist = Irssi::settings_get_int('tmux_pane_index_nicklist');
    $tmux_width = Irssi::settings_get_int('tmux_width');

    &tmux_resize
}

# I need to wait for nicklist_width from nicklist.pl to be set. Without the
# below timeout, the script will fail on autoload with
# -!- Irssi: warning settings_get(nicklist_width) : not found
# even though the setting exists in '~/.irssi/config'.
Irssi::timeout_add_once(10, \&load_settings, undef);

Irssi::signal_add('setup changed', \&sig_setup_changed);
sub sig_setup_changed
{
    &load_settings;
}
### End external settings handling

sub sig_terminal_resized
{
    &tmux_resize
}

sub tmux_get_current_dimensions
{
    my $delimiter = 'x';
    my $result = qx/$tmux display-message -pt $tmux_session_window.$tmux_pane_index_nicklist -F "#{pane_width}$delimiter#{pane_height}"/;
    return split($delimiter, $result);
}

sub tmux_resize
{
    # Get windowlist needed height
    my @windows = Irssi::windows;
    my $windowlist_height = 3 + @windows;

    # Set tmux pane layout
    system(
        $tmux, '-q', 'resize-pane', '-t', $tmux_session_window . '.' . $tmux_pane_index_windowlist,
        '-x', $tmux_width, '-y', $windowlist_height
    );

    # Set nicklist size
    ($current_width, $current_height) = &tmux_get_current_dimensions;
    Irssi::settings_set_int('nicklist_width', $current_width);
    Irssi::settings_set_int('nicklist_height', $current_height);

    # Apply nicklist settings
    Irssi::command('nicklist fifo');
    Irssi::command('nicklist fifo');
}

Irssi::command_bind('tmuxresize',\&tmux_resize);
Irssi::signal_add('terminal resized', \&sig_terminal_resized);
Irssi::signal_add('window created', \&sig_terminal_resized);
Irssi::signal_add('window destroyed', \&sig_terminal_resized);
