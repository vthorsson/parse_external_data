#!/usr/bin/env python
#

# Parse homologene.dat file
#
# VT - March 24, 2004

## homologene has one and only one homologene
## cluster for each integer 1,,,
## and file arranged by increasing homolgene cluster no.

## September 2, 2004
## The cluster for each integer 1,,,
## no longer holds. Seems some homologenes have been deprecated
## Now require only that cluster numbers increase monotonically

import sys
import re

if (len (sys.argv) != 2):
  print 'error!  usage:  human2mouse.py <inputfile> \n'
  sys.exit ()


filename = sys.argv[1]

lines=open(filename).read().split('\n')
lines=lines[:-1]
sys.stderr.write ('found %d lines\n' % len(lines) )

mouseOrgID=10090
humanOrgID=9606

## Seems we miss the last one
def splitByHBlocks(fname):
  blocks=[]
  linesInBlock=[]
  lines=open(fname).read().split('\n')
  lines=lines[:-1]
  currentHID=1
  for line in lines:
    tokens=line.split('\t')
    hid=int(tokens[0])
    if ( hid == currentHID ):
      linesInBlock.append(line)
##    elif (hid==(currentHID+1) ):
    elif ( hid > currentHID ):
      blocks.append(linesInBlock)
      ##reset to start collecting data for next block
##      currentHID=currentHID+1
      currentHID = hid
      linesInBlock=[]
      linesInBlock.append(line)
    else:
      print 'Error'
  return blocks


def getMouseIDs (bloque):
  mouseIDs=[]
  for line in bloque:   
    tokens=line.split('\t')
    ntok=len(tokens)
    if (ntok!=6):
      sys.stderr.write('Wrong number of fields')
    hid=int(tokens[0])
    orgid=int(tokens[1])
    locusID=int(tokens[2])
    if (orgid==mouseOrgID):
      mouseIDs.append(locusID)
  return mouseIDs


def getHumanIDs (bloque):
  humanIDs=[]
  for line in bloque:   
    tokens=line.split('\t')
    ntok=len(tokens)
    if (ntok!=6):
      sys.stderr.write('Wrong number of fields')
    hid=int(tokens[0])
    orgid=int(tokens[1])
    locusID=int(tokens[2])
    if (orgid==humanOrgID):
      humanIDs.append(locusID)
  return humanIDs



def getMouseNPs (bloque):
  mouseNPs=[]
  for line in bloque:   
    tokens=line.split('\t')
    ntok=len(tokens)
    if (ntok!=6):
      sys.stderr.write('Wrong number of fields')
    orgid=int(tokens[1])
    np=tokens[5]
    if (orgid==mouseOrgID):
      mouseNPs.append(np)
  return mouseNPs


def getHumanNPs (bloque):
  humanNPs=[]
  for line in bloque:   
    tokens=line.split('\t')
    ntok=len(tokens)
    if (ntok!=6):
      sys.stderr.write('Wrong number of fields')
    orgid=int(tokens[1])
    np=tokens[5]
    if (orgid==humanOrgID):
      humanNPs.append(np)
  return humanNPs



hblocks=splitByHBlocks(filename)


def stripDotSuffix (instring):
  returnString=instring
  if ( instring.find('.') != -1 ):
    returnString=instring[:instring.find('.')]
  return returnString

for block in hblocks:
  humanNPs=getHumanNPs(block)
  mouseNPs=getMouseNPs(block)
  for humanNP in humanNPs:
    for mouseNP in mouseNPs:
		ph=stripDotSuffix(humanNP)
		pm=stripDotSuffix(mouseNP)
		if ( ("NP_" in ph) and ("NP_" in pm)): # let's drop XP and others
			print stripDotSuffix(humanNP) + '\t' + stripDotSuffix(mouseNP)
