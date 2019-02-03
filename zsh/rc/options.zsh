# Make pushd/popd more convenient by integrating them with normal cd usage.
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME # Push to home directory when no argument is given.

# Change directory to a path stored in a variable.
setopt CDABLE_VARS

# Write to multiple descriptors.
setopt MULTIOS

# Use extended globbing syntax.
setopt EXTENDED_GLOB

# Do not accidentally overwrite existing files with > and >>. Use >! and >>! to bypass.
unsetopt CLOBBER

# Perform path search even on command names with slashes.
setopt PATH_DIRS

# Complete from both ends of a word. (E.g. ab|cd will complete to anything matching ab*cd.)
setopt COMPLETE_IN_WORD

# Move cursor to the end of a completed word.
setopt ALWAYS_TO_END
# If completed parameter is a directory, add a trailing slash.
setopt AUTO_PARAM_SLASH

# Automatically list choices on ambiguous completion.
setopt AUTO_LIST
# Show completion menu on a successive tab press.
setopt AUTO_MENU
# Do not autoselect the first completion entry.
unsetopt MENU_COMPLETE
