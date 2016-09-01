Introduction
------------

I wrote this as a little side project to help with some stationery
work my wife was working on.  The script expects a file called
`names.txt` to exist in the working directory, formatted with one name
per line, like so:

    names.txt:
    1: rob
    2: bob
    ...

(The filename and line numbers are added just for clarity.  You
wouldn't actually want those in there.)

There is a default names.txt in the repository with names from the USA
SSA's list of [top 10 names per gender][1].

[1]: https://www.ssa.gov/OACT/babynames/

Running
-------

By default the script will use a 15x15 board and read names from the
default `names.txt` file.  To run, simply invoke it:

    % ./wordsearch.pl

The script will show its status as it's running.

    Running generation 6... (best so far 17/20)

You see the number of different boards it's tried (generations), along
with the most names it's been able to place.  As soon as an
arrangement is found that places all the names the script will exit
and show the solution:

    Finished on generation 103
    
    Placed names (15 x 15):
      M     E   M i c h a e l     
      a     t                     
      s     h   S       C     W   
      o   J a c o b     h     i   
      n     n   p   M i a     l   
    A   E       h       r     l   
    v   m   A b i g a i l     i   
    a   m   l   a       o     a   
      J a m e s         t     m   
            x           t   L     
    E   N o a h         e l i     
    m       n               a     
    i       d     B e n j a m i n 
    l       e                     
    y   H a r p e r   O l i v i a 
    
    Answer key:
    eli	(10,10)	left/right
    Liam	(12,9)	up/down
    Charlotte	(10,2)	up/down
    Mia	(8,4)	left/right
    Abigail	(4,6)	left/right
    Sophia	(6,2)	up/down
    Jacob	(3,3)	left/right
    Benjamin	(7,12)	left/right
    Ethan	(4,0)	up/down
    Alexander	(4,6)	up/down
    Noah	(2,10)	left/right
    Ava	(0,5)	up/down
    Olivia	(9,14)	left/right
    James	(1,8)	left/right
    Harper	(2,14)	left/right
    Michael	(6,0)	left/right
    William	(13,2)	up/down
    Emily	(0,10)	up/down
    Mason	(1,0)	up/down
    Emma	(2,5)	up/down

The format of the answer key is:

    Name    (x,y)  direction

Where (0,0) is the top-left of the board.

Tweaking
--------

The board size is tuned via the `$SIZE` variable on line 14.  The
board is assumed to be square, but you could change that if you
wanted.  Other than that the biggest thing is the rules that it
follows, which you can find around lines 69-183 in place_name().

Happy hacking!
