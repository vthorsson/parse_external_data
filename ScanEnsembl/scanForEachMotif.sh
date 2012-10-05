#!/bin/bash
## March 2008
##
## MotifLocator Wrapper:
## Scan with all matrices, at specified threshold for each each 
## Produces one output file per motif
 
WRONGARGS=1
if [ $# != 2 ]
then
  echo "Usage: `basename $0` <fasta file> <thresholdFile>" >&2
  exit $WRONGARGS
fi

thresholdFile=$2
outfile=$3
seqbase=`basename $1 .fasta`
matrixDir=$CODE_DIR/newmatrixes
outdir="scanPerMotif/"

matfiles=(`ls $matrixDir/*.dat`)


for (( i = 0 ; i < ${#matfiles[@]} ; i++ ))
##for (( i = 0 ; i < 3 ; i++ ))

do
    mat=`basename ${matfiles[$i]} .dat`
    threshold=`grep ^$mat'\b' $thresholdFile | awk '{print $2}'`
    outfile=$outdir$mat".gff"
    echo "Generating $outfile"
    $CODE_DIR/MotifLocator_linux -f $1  -b $CODE_DIR/bModel.fa -m ${matfiles[$i]} -t $threshold -o $outfile >& /dev/null
    
done
    