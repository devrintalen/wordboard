#!/usr/bin/perl

# wordsearch.pl: generate scrabble-style boards
# Copyright (C) 2016  Devrin Talen
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use List::Util 'shuffle';
use List::Util 'max';
use List::MoreUtils 'first_index';

open(NAMES, "names.txt") or die "Can't open names.txt: $!\n";

while (chop($line = <NAMES>)) {
    push @names, $line;
}

$SIZE = 15;
my @ws;
my @answers;

# Finds a place for a name and returns the fitness (number of re-used
# letters) for that placement.  Does not commit the placement to @ws.
sub place_name {
    $name = $_[0];

    my $placed = 0;
    while (!$placed) {
	# Pick a random location to try to put this name
	$x = int(rand $SIZE);
	$y = int(rand $SIZE);
	$dir = int(rand(2));

	# First see if it's out of bounds
	redo if (($dir == 0) && ($x + length($name) > $SIZE));
	redo if (($dir == 1) && ($y + length($name) > $SIZE));

	# Here's a special case for the thing I wrote this script for.
	# It's commented out, but if you have some guy named eli that
	# you want at location (8,9) going sideways then knock
	# yourself out.
	#
	# Special case: ELI
	#if ($name eq "eli") {
	#    $x = 8;
	#    $y = 9;
	#    $dir = 0;
	#}

	if ($dir == 0) {
	    #print "Trying location ($x, $y), left to right\n";
	} else {
	    #print "Trying location ($x, $y), up/down\n";
	}
	
	# This spot is okay to try
	$placed = 1;
    }
	
    # Now see if the letters work out.  Two rules:
    # 1. Can't collide with letters from another name.
    # 2. Can't have letters next to it if we're not going
    #    through another name.
    $cur_x = $x;
    $cur_y = $y;
    $index = 0;
    $fitness = 0;
    foreach $letter (split "", $name) {
	$index++;
	#print "Testing location ($cur_x, $cur_y)\n";
	$test_letter = $ws[$cur_x][$cur_y];
	if ($test_letter ne " ") {
	    # There's a letter in the spot we want to move through
	    if ($test_letter ne $letter) {
		#print "Found different letter '$test_letter'\n";
		return (-1, 0, 0, 0);
	    } else {
		#print "Found the same letter '$test_letter'\n";

		# If this is the first or last letter there are some
		# stipulations.
		if ($index == 1) {
		    if ($dir == 0 && $cur_x > 0) {
			# Make sure there's no letter to the left of
			# us
			if ($ws[$cur_x - 1][$cur_y] ne " ") {
			    return (-1, 0, 0, 0);
			}
		    } elsif ($dir == 1 && $cur_y > 0) {
			# Make sure there's no letter above us
			if ($ws[$cur_x][$cur_y - 1] ne " ") {
			    return (-1, 0, 0, 0);
			}
		    }
		} elsif ($index == length($name)) {
		    if ($dir == 0 && $cur_x < ($SIZE - 1)) {
			# Make sure there's no letter to the right of
			# us if we're not on the right edge.
			if ($ws[$cur_x + 1][$cur_y] ne " ") {
			    return (-1, 0, 0, 0);
			}
		    } elsif ($dir == 1 && $cur_y < ($SIZE - 1)) {
			# Make sure there's no letter beneath us if
			# we're not on the last row.
			if ($ws[$cur_x][$cur_y + 1] ne " ") {
			    return (-1, 0, 0, 0);
			}
		    }
		}
		
		$fitness++;
	    }
	} else {
	    # The spot we want to move through is blank, so make
	    # sure there's no filled in tiles next to us.
	    #print "Checking around us\n";
	    if ($dir == 0) {
		if ($cur_y != 0) {
		    # check above us if we're not at the top row
		    if ($ws[$cur_x][$cur_y - 1] ne " ") {
			return (-1, 0, 0, 0);
		    }
		}
		if ($cur_y != $SIZE - 1) {
		    # check below us if we're not at the bottom row
		    if ($ws[$cur_x][$cur_y + 1] ne " ") {
			return (-1, 0, 0, 0);
		    }
		}
		if ($index == 1 && $cur_x > 0) {
		    # check left of us if this is the first letter
		    # and we're not at the left edge.
		    if ($ws[$cur_x - 1][$cur_y] ne " ") {
			return (-1, 0, 0, 0);
		    }
		}
		if ($index == length($name) && $cur_x < ($SIZE - 1)) {
		    # check right of us if this is the last letter
		    # and we're not on the right edge.
		    if ($ws[$cur_x + 1][$cur_y] ne " ") {
			return (-1, 0, 0, 0);
		    }
		}
	    } else {
		if ($cur_x != 0) {
		    # check left of us if we're not on the left edge
		    if ($ws[$cur_x - 1][$cur_y] ne " ") {
			return (-1, 0, 0, 0);
		    }
		}
		if ($cur_y != $SIZE - 1) {
		    # check right of us if we're not on the right edge
		    if ($ws[$cur_x + 1][$cur_y] ne " ") {
			return (-1, 0, 0, 0);
		    }
		}
		if ($index == 1 && $cur_y > 0) {
		    # check above us if this is the first letter
		    # and we're not on the top row
		    if ($ws[$cur_x][$cur_y - 1] ne " ") {
			return (-1, 0, 0, 0);
		    }
		}
		if ($index == length($name) && $cur_y < ($SIZE - 1)) {
		    # check below us if this is the last letter
		    # and we're not on the bottom edge.
		    if ($ws[$cur_x][$cur_y + 1] ne " ") {
			return (-1, 0, 0, 0);
		    }
		}
	    }
	    
	}

	#print "Location is okay\n";

	if ($dir == 0) {
	    $cur_x++;
	} else {
	    $cur_y++;
	}
    }

    # make sure we didn't just re-use the same name
    if ($fitness == length($name)) {
	#print "Re-used a name, aborting\n";
	return (-1, 0, 0, 0);
    }

    return ($fitness, $x, $y, $dir);
}

sub record_placement {
    my @params = @_;
    my $name = $params[0];
    my $x = $params[1];
    my $y = $params[2];
    my $dir = $params[3];
    
    $cur_x = $x;
    $cur_y = $y;
    foreach $letter (split "", $name) {
	$ws[$cur_x][$cur_y] = $letter;
	if ($dir == 0) {
	    $cur_x++;
	} else {
	    $cur_y++;
	}
    }

    push @answers, "$name $x $y $dir";
}

sub run_generation {
    # Initialize the board
    for (my $y = 0; $y < $SIZE; $y++) {
	for (my $x = 0; $x < $SIZE; $x++) {
	    $ws[$x][$y] = " ";
	}
    }
    @answers = ();

    # Pick a random name to start on
    my @shuffled_names = shuffle(@names);
    my $total = scalar(@shuffled_names);

    # Same deal as before, this code is specific to my needs but not
    # deleted just in case you want it.
    #
    # Make sure that ELI gets placed first
    my $eli_index = first_index { /eli/ } @shuffled_names;
    $shuffled_names[$eli_index] = $shuffled_names[0];
    $shuffled_names[0] = "eli";

    my $i = 1;
    foreach $name (@shuffled_names) {
	#print "[$i/$total] Placing $name ";

	my $tries = 1000;
	my $best_fitness = -1;
	my %places;
	while ($best_fitness < 2 && $tries > 0) {
	    ($fitness, $x, $y, $dir) = place_name($name);

	    #print "Placed $name with fitness $fitness x $x y $y dir $dir\n";
	    $places{$fitness} = "$x $y $dir";

	    if ($fitness > $best_fitness) {
		$best_fitness = $fitness;
	    }
	    
	    $tries--;
	}
	my @fits = keys %places;
	my $bestfit = max @fits;
	($x, $y, $dir) = split " ", $places{$bestfit};
	#print "(fitness $bestfit)\n";
	#die "Couldn't find a fit, so quitting.\n" if ($bestfit < 0);
	if ($bestfit < 0) {
	    #print "Couldn't find a fit\n";
	    return $i - 1;
	}
	
	# Now record it
	record_placement($name, $x, $y, $dir);
	$i++;
    }

    return $i - 1;
}

my $generations = 0;
my $placed_names = 0;
my $best_so_far = 0;
my $total_names = scalar(@names);
$| = 1;
while ($placed_names != $total_names) {
    print "Running generation $generations... (best so far $best_so_far/$total_names)      \r";
    $placed_names = run_generation();
    if ($placed_names > $best_so_far) {
	$best_so_far = $placed_names;
	# and write it out...
	open(RESULTS, ">", "results.txt")
	    or die "Can't open results.txt: $!\n";

	print RESULTS "Placed names ($SIZE x $SIZE):\n";
	for (my $y = 0; $y < $SIZE; $y++) {
	    for (my $x = 0; $x < $SIZE; $x++) {
		print RESULTS "$ws[$x][$y] ";
	    }
	    print RESULTS "\n";
	}
	print RESULTS "\nAnswer key:\n";
	foreach $line (@answers) {
	    ($name, $x, $y, $dir) = split " ", $line;
	    if ($dir == 0) {
		$dir_name = "left/right";
	    } else {
		$dir_name = "up/down";
	    }
	    print RESULTS "$name\t($x,$y)\t$dir_name\n";
	}

	close(RESULTS);
    }
    $generations++;
}

print "Finished on generation $generations                        \n\n";

# Print out the wordsearch
print "Placed names ($SIZE x $SIZE):\n";
for (my $y = 0; $y < $SIZE; $y++) {
    for (my $x = 0; $x < $SIZE; $x++) {
	print "$ws[$x][$y] ";
    }
    print "\n";
}

# Print out the answer key
print "\nAnswer key:\n";
foreach $line (@answers) {
    ($name, $x, $y, $dir) = split " ", $line;
    if ($dir == 0) {
	$dir_name = "left/right";
    } else {
	$dir_name = "up/down";
    }
    print "$name\t($x,$y)\t$dir_name\n";
}
