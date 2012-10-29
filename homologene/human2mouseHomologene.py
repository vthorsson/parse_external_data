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

# beware, might need to handle multiple occurences
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

# beware, might need to handle multiple occurences
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


hblocks=splitByHBlocks(filename)


for block in hblocks:
  humanIDs=getHumanIDs(block)
  mouseIDs=getMouseIDs(block)
  ##print str(len(humanIDs)) + '\t' + str(len(mouseIDs))
  for humanID in humanIDs:
    for mouseID in mouseIDs:
      print str(humanID) + '\t' + str(mouseID)

      
