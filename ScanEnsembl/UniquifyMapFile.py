#!/usr/bin/env python
##
## Apply heuristic to get unique ensembl IDs from gene2ensembl_simplified_mouse
##
## Choose numerically lowest Entrez ID where there are multiples
##

import sys
import re

lines = open('gene2ensembl_simplified_mouse').read().split('\n')
lines = lines[:-1]
nlines = len(lines)
sys.stderr.write ('found %d lines in %s\n' % (nlines,'gene2ensembl_simplified_mouse') )


eidsOfensids = {}
for ll in lines:
    toks = ll.split('\t')
    eid = toks[1]
    ensid = toks[0]
    if eidsOfensids.has_key(ensid):
        eidsOfensids[ensid].append(int(eid))
    else:
        eidsOfensids[ensid]=[int(eid)]
print 'Ensembl Gene ID\tEntrezGene ID'

for ensid in eidsOfensids.keys():
    print ensid + '\t' + str(min(eidsOfensids[ensid]))
    
