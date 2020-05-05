#!/usr/bin/perl

#use 5.016;
use utf8;
use open qw/:std :utf8/;

# FixPOS-ind.pl < infile.db > outfile.db

# (Make a copy of this file, and in the copy replace the NNN in the filename
# with the language code for the language you will apply this to.  Then 
# customize the rules below for what occurs in that specific database.)

# Make the POS labels more consistent; change \ps to \orig_ps (original).
# Add a new field \ps for a smaller set of labels.
# Leave \ps empty for all affixes.

$logfile = "poslog.txt";
open(LOGFILE, ">$logfile");

$afffile = "ListOfAffixes.txt";
open(AFFFILE, ">$afffile");
print AFFFILE "Affixes found:\n";
print AFFFILE "(In FLEx, Part of Speech has a different meaning for affixes than stems.\n";
print AFFFILE "Thus, the \ps field has been made empty for these affixes for the FLEx import.\n";

$linecount = 0;

print LOGFILE "\\ps fields that didn't match the script; may need checking\n\n";

# iterate through the file, reading one line each time through the loop,
# until there are no more lines
while ($line = <>) {
	# remove the end-of-line character, whatever it is
	chomp $line;
	$linecount++;
	
	# beginning of new record
	# Check whether this is an affix or not
	if ($line =~ /^\\lx (.*)$/) {
		$lx = $1;
		#print STDERR "lx = $lx\n";
		# Reinitialize
		$orig_ps = $psn = "";
		$affix = 0;
		if ($lx =~ /^[=-]/ || $lx =~ /[=-]$/) {
			$affix = 1;
			}
		print "$line\n";
		}

	# For the \ps line, do special processing
	elsif ($line =~ /^\\ps (.*)$/) {
		#$orig_ps = $psn = "";
		$orig_ps = $1;
		# Strip trailing spaces
		$orig_ps =~ s/ *$//;
		# Strip leading spaces
		$orig_ps =~ s/^ *//;
		#print STDERR "orig_ps = $orig_ps\n";
		
		
		# Start by making the new ps the same as the original.
		# It will get modified by the rules below if necessary.
		$psn = $orig_ps;

		# Put a placeholder for the ones that need individual attention
		# from the linguist.  Instruct the linguist to search for these and adjust them.
		if ($orig_ps =~ /[,;\?-]/) {
			$psn = "FIX";
			}
		# Make a normalized form of some that were inconsistent.
		# (This version makes them all match the FLEx default abbrevs, but it is better
		# to adjust FLEx to use the abbreviations that the linguist wants, and
		# to match what is in the data.)
		
		# EDIT THE FOLLOWING PATTERNS TO MATCH WHAT OCCURS IN THE DATABASE
		elsif ($orig_ps =~ /^quan/) {
			$psn = "quant";
			## Debug output, just to verify that *something* is happening:
			#print STDERR "Changed $orig_ps to $psn\n";
			}
		elsif ($orig_ps =~ /^intj/ || $orig_ps =~ /^excl/) {
			$psn = "interj";
			}
		elsif ($orig_ps =~ /^[Aa]dj/) {
			$psn = "adj";
			}
		# It would be better to adjust the Category "Connective" in FLEx.
		# Change its Name to "Conjunction" and its Abbreviation to "conj".
		elsif ($orig_ps =~/^[Cc]onj/) {
			$psn = "conn";
			}
		# END OF PATTERNS TO EDIT
		
#		## The following were some routines I have done for some databases,
#		## but there are tricks to using them well, so they are commented out
#		## in this version.
#		# These are okay as they are; copy into \psn
#		elsif ($orig_ps =~ /^n$/ || $orig_ps =~ /^v$/ || $orig_ps =~ /^vi/ || $orig_ps =~ /^vs/ || $orig_ps =~ /^vt/) {
#			$psn = $orig_ps;
#			}
#		# Document any POS that wasn't matched by any of the above patterns
#		# (Only do this if you made an exhaustive list of the ones that are acceptable "as is".
#		# But often it isn't necessary to be that thorough.)
#		else {
#			if (!$affix) {
#				print LOGFILE "\\orig_ps $orig_ps\n";
#				}
#			}

		# Ready to output the file
		
		# Don't print the new POS for affixes
		# In FLEx, the "category" for an affix is "the category it attaches to".
		# That is never what the \ps value in Toolbox means, for an affix.
		# So leave \ps blank for all affixes.
		if ($affix) {
			$psn = "";
			print "\\ps \n";
			# And log which affixes we saw and what their POS was
			print AFFFILE "$lx was originally \\ps $orig_ps\n";
			}
		# But do print it for everything else
		else {
			print "\\ps $psn\n";
			}
		# Only put the old POS in \orig_ps if it is different
		# from the new ps, or it is one that needs special attention.  
		# (This will be imported into a custom field "OrigPOS".)
		# This will make it easier to find the ones that need to be 
		# checked (in FLEx),
		# and to delete the value from OrigPOS (in FLEx) once they are fixed.
		if ($psn ne $orig_ps) {
			print "\\orig_ps $orig_ps\n";
			}
		}
	else {
		# Any line that is not a \ps just needs to be printed
		print "$line\n";
		}
	}

