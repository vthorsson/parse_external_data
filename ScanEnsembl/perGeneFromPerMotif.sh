#!/bin/bash
## March 2008
##
## Create Per Gene GFF files from Per Motif GFF files
 
WRONGARGS=1
if [ $# != 0 ]
then
  echo "Usage: `basename $0`" >&2
  exit $WRONGARGS
fi

fastaHeaders=(`cat fastaHeaders`)
fastaFiles=(`cat fastaFileList`)

perMotifScanDir="scanPerMotif"
gffDir="allMouseUpstreamGFF"

##for (( i =  0 ; i < 2 ; i++ ))

for (( i = 0 ; i < ${#fastaFiles[@]} ; i++ ))

do
    fastaHeader=${fastaHeaders[$i]}
    seq=`basename ${fastaFiles[$i]} .fasta`
    outfile=$gffDir/$seq.gff
    if [ ! -f $outfile ] ; then
	echo "Generating $outfile"
	grep -h $fastaHeader $perMotifScanDir/*.gff |  sort -k 5  -nr > $outfile
    else
	echo "$outfile exists. Moving on."
    fi
done
