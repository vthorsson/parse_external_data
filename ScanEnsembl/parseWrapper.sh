#!/bin/bash
## July 2006
##

 
gffDir="allMouseUpstreamGFF"
parsedDir="allMouseUpstreamParsedGFF"

gffFiles=(`cat gffFileList`)
##gffFiles=(`ls $gffDir/*.gff`)
 
 
for (( i = 0 ; i < ${#gffFiles[@]} ; i++ ))
##for (( i = 0 ; i < 3 ; i++ ))
 
do 
    seq=`basename ${gffFiles[$i]} .gff`
    gffFile=${gffFiles[$i]}
    outfile=$parsedDir/$seq.gff.parsed
    if [ -e $gffDir/$gffFile ]
	then
	    echo "Processing $gffDir/$gffFile to get $outfile"
	    $CODE_DIR/parseScanResult.py $gffDir/$gffFile > $outfile
	else
	    echo "$gffDir/$gffFile not found"
    fi
done

