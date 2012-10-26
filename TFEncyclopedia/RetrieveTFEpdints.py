#
# Retrieve protein-DNA interactions from 
# Transcription Factor Encyclopedia 
#
# Uses API 
## http://www.cisreg.ca/cgi-bin/tfe/about.pl?page=api 
import sys
import re
import urllib2

if (len (sys.argv) != 2):
  print 'error!  usage:  RetrieveTFEpdints.py <mouse or human>\n'
  sys.exit ()

if (sys.argv[1]=="mouse"):
	desiredSpecies = "Mus musculus"
if (sys.argv[1]=="human"):
	desiredSpecies = "Homo sapiens"

## Retrieve all possible transcription factor IDs
prefix="http://www.cisreg.ca/cgi-bin/tfe/api.pl?"
qstring=prefix+"code=all-tfids"
alltfids=urllib2.urlopen(qstring).read().split()

# Filter tfids to organism of interest
orgtfids = []
for tfid in alltfids:
	qstring=prefix + "tfid=" + tfid + "&code=species"
	species=urllib2.urlopen(qstring).read().strip()
	if species == desiredSpecies:
		orgtfids.append(tfid)

## Retrieve and output targets 
## Targets can be from other organism
print "TF_entrezID\ttfid\tTarget_EntrezID\tTarget_Symbol\tTF complex\tPubMedID\tSource"
for tfid in orgtfids:
	qstring=prefix + "tfid=" + tfid + "&code=entrez-gene-id"
	tfentrezID=urllib2.urlopen(qstring).read().strip()
	qstring=prefix + "tfid=" + tfid + "&code=targets"
	lines=urllib2.urlopen(qstring).read().split('\n')[:-1]
	for line in lines:
		print tfentrezID + '\t' + tfid + '\t' + line


