#!/usr/bin/env python
 
import sys
import re
 
if (len (sys.argv) != 5):
  print 'error!  usage:  generateFastaFiles.py <big fasta file from BioMart> <ncbi mapping file> <ensembl to entrez file ><mode>\n'
  print '<mode> is one of (headers, filelist, files, singlebig)\n'
  sys.exit ()

filename = sys.argv[1]

## split on the fast carat, but don't forget to re-insert it
seqs = open(filename).read().split('>')
seqs = seqs[1:]
nseqs = len(seqs)
sys.stderr.write ('found %d sequences in %s\n' % (nseqs,filename) )
 
geneinfofile = sys.argv[2]
lines = open(geneinfofile).read().split('\n')
lines = lines[:-1]
nlines = len(lines)
sys.stderr.write ('found %d lines in %s\n' % (nlines,geneinfofile) )
genesymbol = {}
for ll in lines:
  toks = ll.split('\t')
  genesymbol[toks[0]]=toks[1]

ensid2eidfile = sys.argv[3]
lines = open(ensid2eidfile).read().split('\n')
lines = lines[:-1]
lines = lines[1:]
nlines = len(lines)
sys.stderr.write ('found %d lines in %s\n' % (nlines,ensid2eidfile) )
eidofensid = {}
for ll in lines:
  toks = ll.split('\t')
  eidofensid[toks[0]]=toks[1]
  
## fh = fasta Header

### If single big file output, open file for writing
if ( sys.argv[4]=='singlebig' ):
  ofile = 'all.fasta'
  fd = open(ofile,mode='w')

for seq in seqs:
  seq = '>' + seq ## adding carat back in, as per above comment
  firstLineFeedIndex = seq.find('\n')
  fhOrig = seq[0:firstLineFeedIndex]
  acgt = seq[(firstLineFeedIndex+1):] ## actual sequence, included line feeds ( but not at end)
  toks = fhOrig.split('|')
  ensemblID = toks[0][1:]
  if ( len(toks) == 2 ):
    if ( eidofensid.has_key(ensemblID) ):
      if ( eidofensid[ensemblID] != '') :
        eid=eidofensid[ensemblID]
        if ( genesymbol.has_key(eid)):
          geneName=genesymbol[eid]
          geneID=eid
          ensemblIDnumberOnly=ensemblID[7:].lstrip('0') ## remove prefix, strip leading zeros
          ofile = geneName +'-' + geneID +'-' + ensemblIDnumberOnly + '.fasta'
      
          if ( sys.argv[4]=='filelist' ): ## File name output
            print ofile
          if ( sys.argv[4]=='headers' ): ## Fasta header output (no carat)
            fhNew = geneName +'|' + geneID +'|' + ensemblID
            print fhNew
          if ( sys.argv[4]=='files' ): ### One-by-one File Output
            fhNew = '>'+geneName +'|' + geneID +'|' + ensemblID
            fd = open(ofile,mode='w')
            contents = fhNew +'\n' + acgt ## acgt has one line feed 
            fd.write(contents)
            fd.close()
          if ( sys.argv[4]=='singlebig' ):  ### Single huge File Output
            fhNew = '>'+geneName +'|' + geneID +'|' + ensemblID
            contents = fhNew +'\n' + acgt ## acgt has one line feed 
            fd.write(contents)

if ( sys.argv[4]=='singlebig' ):
  fd.close()
