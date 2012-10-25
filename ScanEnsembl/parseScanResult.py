#!/usr/bin/env python
#
# VT - July , 2006 
# parse the sequence gff score results
 
import sys
import re
 
if (len (sys.argv) != 2):
  print 'error!  usage:  parseScanResult.py <.gff file> \n'
  sys.exit ()
 
filename = sys.argv[1]
lines = open(filename).read().split('\n')
lines = lines[:-1]
nlines = len(lines)
sys.stderr.write ('found %d lines in %s\n' % (nlines,filename) )

regionLength=1000
 
for line in lines:
    fields = line.split('\t')
    if ( len(fields) != 9 ):
        sys.stderr.write("The following line does not have 9 fields\n")
    matrix = fields[8].split(";")[0].split()[1].strip('\"')
    startHit = int(fields[3])-regionLength-1
    endHit = int(fields[4])-regionLength-1
    score=fields[5]
    strand=fields[6]

    print matrix + '\t' + score+ '\t'+ str(endHit) +'\t' + strand
##    print matrix +'\t' + str(startHit) +'\t' + str(endHit) +'\t' + strand
