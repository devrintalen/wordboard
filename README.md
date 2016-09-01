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

    Finished on generation 1488                         
    
    Placed names (15 x 15):
    E m i l y   A v a         L   
                b     S o p h i a 
        W i l l i a m         a   
                g             m   
      O   C   H a r p e r         
      l   h     i           B     
      i   a   A l e x a n d e r   
      v   r                 n     
      i   l                 j     
    J a c o b       M i c h a e l 
          t   E m m a       m     
          t         s     M i a   
    J a m e s     N o a h   n     
                    n             
    I s a b e l l a   E t h a n   
    
    Answer key:
    Jacob	(0,9)	left/right
    Charlotte	(3,4)	up/down
    Olivia	(1,4)	up/down
    Mason	(8,9)	up/down
    James	(0,12)	left/right
    Alexander	(5,6)	left/right
    Benjamin	(12,5)	up/down
    Abigail	(6,0)	up/down
    William	(2,2)	left/right
    Sophia	(9,1)	left/right
    Emma	(5,10)	left/right
    Harper	(5,4)	left/right
    Ethan	(9,14)	left/right
    Isabella	(0,14)	left/right
    Michael	(8,9)	left/right
    Mia	(11,11)	left/right
    Noah	(7,12)	left/right
    Liam	(13,0)	up/down
    Emily	(0,0)	left/right
    Ava	(6,0)	left/right

The format of the answer key is:

    Name    (x,y)  direction

Where (0,0) is the top-left of the board.

While the script is running it will output the best board so far to a
file named `results.txt`.  This is to save progress and give you
something to use in case you demand too much of it and it simply never
finds a solution to placing all the names in the board size you want.

Tweaking
--------

The board size is tuned via the `$SIZE` variable on line 14.  The
board is assumed to be square, but you could change that if you
wanted.  Other than that the biggest thing is the rules that it
follows, which you can find around lines 69-183 in place_name().

Happy hacking!
