# FixPOS
Script for normalizing \ps valules in an SFM file.

REQUIRED MODULES: None

INPUT/OUTPUT FILES: specified on command line (STDIN/STDOUT)

USAGE:  perl ./FixPOS-NNN.pl <  MyDatabase.db > MyDatabase-POS.db

LOGFILES:
 * poslog.txt: a logfile containing any \ps fields with values that
 didn't match any of the patterns in the file, in case they need to be
 checked further.
 * ListOfAffixes.txt: lists the affixes that were found in the database,
 since they won't be assigned any POS.  Verify that these are truly affixes.

SAMPLE FILES:
  * Sample input:	SampleIndo-BeforePOS.db
  * Sample output:	SampleIndo-AfterPOS.db

SAMPLE USAGE:
  * ./FixPOS-NNN.pl < SampleIndo-BeforePOS.db > SampleIndo-AfterPOS.db

----------
NOTES

This script is a "template script", meaning that it has a framework that
works with any database, but the core part of it tries to match data in 
a specific database, and as such it needs to be customized every time it
is used on different data.

After downloading this script, make a copy of it and replace NNN in the
filename with a code for your language.

Then in the copy, edit the patterns for \ps values to match whatever needs
to be done for the data you are working with.  (Search for "EDIT" to find
the place to edit.)  It will likely be an
iterative process:  as you fix some, and then make a list of the new
set of \ps values, you will see others that need to be normalized, and
you will edit again.  Keep editing, applying the script, and then making
a list of the resulting \ps values until you are satisfied with the 
resulting list.

Then customize the empty FLEx database so it is pre-populated with all
of these POS values (both Names and Abbreviations) before you do the
import (and make a backup of the empty database after you add the POS
values but before you import, in case you need to return to it after
some trial import attempts).

