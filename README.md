I wrote this as a little side project to help with some stationery
work my wife was working on.  The script expects a file called
`names.txt` to exist in the working directory, formatted with one name
per line, like so:

    names.txt:
    1: rob
    2: bob

(The filename and line numbers are added just for clarity.  You
wouldn't actually want those in there.)

The board size is tuned via the `$SIZE` variable on line 14.  The
board is assumed to be square, but you could change that if you
wanted.

The last thing is that there's code on lines 25-27 and 42-46 to handle
a special case for the thing I wrote this script for, so you'll
probably want to delete those lines.
