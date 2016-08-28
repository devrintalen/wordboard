#!/usr/bin/perl

use List::Util 'shuffle';
use List::MoreUtils 'first_index';

open(NAMES, "names.txt") or die "Can't open names.txt: $!\n";

while (chop($line = <NAMES>)) {
    push @names, $line;
}

# Initialize the board
my @ws;
$SIZE = 20;
for (my $y = 0; $y < $SIZE; $y++) {
    for (my $x = 0; $x < $SIZE; $x++) {
	$ws[$x][$y] = " ";
    }
}

# Pick a random name to start on
@shuffled_names = shuffle(@names);

# But make sure that ELI gets placed first
my $eli_index = first_index { /eli/ } @shuffled_names;
$shuffled_names[$eli_index] = $shuffled_names[0];
$shuffled_names[0] = "eli";

foreach $name (@shuffled_names) {
    #print "Placing $name\n";
    my $placed = 0;
    my $tries = 500;
    
  PLACE:
    while (!$placed && $tries > 0) {
	# Pick a random location to try to put this name
	$x = int(rand $SIZE);
	$y = int(rand $SIZE);
	$dir = int(rand(2));

	# Special case: ELI
	if ($name eq "eli") {
	    $x = 8;
	    $y = 9;
	    $dir = 0;
	}

	if ($dir == 0) {
	    #print "Trying location ($x, $y), left to right\n";
	} else {
	    #print "Trying location ($x, $y), up/down\n";
	}
	
	# First see if it's out of bounds
	next PLACE if (($dir == 0) && ($x + length($name) > $SIZE));
	next PLACE if (($dir == 1) && ($y + length($name) > $SIZE));
	
	# Now see if the letters work out
	$cur_x = $x;
	$cur_y = $y;
	$same_letters = 0;
	foreach $letter (split "", $name) {
	    #print "Testing location ($cur_x, $cur_y)\n";
	    $test_letter = $ws[$cur_x][$cur_y];
	    if ($test_letter ne " ") {
		if ($test_letter ne $letter) {
		    #print "Found different letter '$test_letter'\n";
		    $tries--;
		    next PLACE;
		} else {
		    #print "Found the same letter '$test_letter'\n";
		    $same_letters++;
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
	if ($same_letters == length($name)) {
	    print "Re-used a name, trying again\n";
	    $tries--;
	    next PLACE;
	}

	$placed = 1;
    }

    die "Couldn't place $name\n" if (!$placed);
    
    # Record the letters since it must have worked out
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

# Print out the wordsearch
print "Placed names:\n";
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
