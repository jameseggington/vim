# Create an event that saves a session automatically on closing vim and reloads
#it next time vim is opened. If vim is started with a file command argument,
#that argument is the first buffer shown.

# Stop copy/paste inserting character codes at start and end of string

# Display file name
Ctrl-g

# Jump to last position in last file
Ctrl-6 goes to the 'alternate' file, which is usually the last file
visited.

# Delete x words before cursor?
Use visual mode and w/b to select whole words.

# Delete up to character
<command> l or <command> h will affect one character right or left

# Param text object
Use the vim-angry plugin, which gives two text objects: aa, which
includes the separator, and ia, which does not.

# Uppercase/lowercase letter/word
Created new mapping in normal mode from t to ~, so toggle with t
Use ~ to toggle case of current letter, or in visual mode u/U

# Increment/decrement a number
Increment Ctrl-A, Decrement Ctrl-X

# Get current mapping for key in mode
To get custom mappings (not made by default, just plugins and vimrc) just enter the map,nmap,imap or other mode mapping command. Without an argument it returns all custom mappings for that mode and with one the mapping for that argument.
