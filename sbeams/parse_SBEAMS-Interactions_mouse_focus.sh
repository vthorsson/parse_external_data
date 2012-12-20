#!/bin/bash
#
# Parse tsv downloads from SBEAMS-Interactions
#
# Convert human interactions to mouse when possible

# There are 30 mixed interactions in total set
# awk 'BEGIN {FS="\t"}{if ($3 == "Homosapiens" && $4=="Musmusculus") {print}}' cleaned.tsv | wc -l 
#      18
# awk 'BEGIN {FS="\t"}{if ($4 == "Homosapiens" && $3=="Musmusculus") {print}}' cleaned.tsv | wc -l 
#      12
# Will stick to organism-specific interactions here

# Alter this according to need
inputfile=SBEAMS-Transfac.tsv ## turns out not to have human
inputfile=SBEAMS-Kitano.tsv
inputfile=SBEAMS-MacrophageActivation.tsv
tag=`basename $inputfile .tsv`

# Start by stripping white spaces and retaining only NPs, and organism columns 
~/bin/reMap.py tte  1 ../homologene/human2mouseRefSeqID.tsv 5 2 True > tte.human.eid # True irrelevant since all map
~/bin/reMap.py tte 1 gene2refseqSimplified_mouse 1 3 | awk '{ if ($1 !="-") print }' > tte.np
awk '{{FS="\t"; OFS="\t"} {print $4,$13,$7,$16} }' $inputfile | sed 's/\ //g' > stripped.tsv
head -1 stripped.tsv > header
awk 'BEGIN {FS="\t"}{if ($1 ~ /NP_/ &&  $2 ~ /NP_/ ) print } ' stripped.tsv > tempfile
cat header tempfile > cleaned.tsv

#
# NP based
#
cut -f 3  gene2refseqSimplified_mouse |awk '{ if ($1 !="-") print }' | tail -n +2 > current_mouse_nps
~/bin/keepRows.py cleaned.tsv 1 current_mouse_nps  > t2
~/bin/keepRows.py t2 2 current_mouse_nps | cut -f 1,2 > $tag.mouse_direct_NP.all.tsv 
~/bin/keepRows.py $tag.mouse_direct_NP.all.tsv 1 tte.np > t2
~/bin/keepRows.py t2 2 tte.np > $tag.mouse_direct_NP.tfcof.tsv 

cut -f 3  gene2refseqSimplified_human |awk '{ if ($1 !="-") print }' | tail -n +2 > current_human_nps
~/bin/keepRows.py cleaned.tsv 1 current_human_nps  > t2
~/bin/keepRows.py t2 2 current_human_nps | cut -f 1,2 > $tag.human_direct_NP.all.tsv 

~/bin/keepRows.py $tag.human_direct_NP.all.tsv 1 tte.np > t2
~/bin/keepRows.py t2 2 tte.np > $tag.human_direct_NP.tfcof.tsv 

# map to mouse using homolegene (current uses only the single representative protein per organism!)
~/bin/reMap.py $tag.human_direct_NP.all.tsv 1 human2mouseRefSeqID.tsv 3 4 > t2
~/bin/reMap.py t2 2 human2mouseRefSeqID.tsv 3 4 > $tag.mouse_mappedFromHuman_NP.all.tsv
~/bin/keepRows.py $tag.mouse_mappedFromHuman_NP.all.tsv 1 tte.np > t2
~/bin/keepRows.py t2 2 tte.np > $tag.mouse_mappedFromHuman_NP.tfcof.tsv 

#
# Entrez ID-based
#

## grab mouse-specific interactions
~/bin/reMap.py cleaned.tsv 1 gene2refseqSimplified_mouse 3 1 True > t1 
~/bin/reMap.py t1 2 gene2refseqSimplified_mouse  3 1 True > t2 ## includes fitering out of non-mouse
cat header t2 > $tag.mouse_direct_GeneID.all.tsv
## $tag.mouse_direct_GeneID.all.tsv should be all mouse mouse interactions in terms of eid
## now filter to one interaction partner being tte
~/bin/keepRows.py $tag.mouse_direct_GeneID.all.tsv 1 tte  > mleft.eid 
~/bin/keepRows.py $tag.mouse_direct_GeneID.all.tsv 2 tte  > mright.eid 
tail -n +2 mleft.eid > ml.eid
tail -n +2 mright.eid > mr.eid 
cat ml.eid mr.eid | cut -f 1,2 > $tag.mouse_direct_GeneID.tfcof.tsv

## Human-human interations, mapped to mouse
## first map interactions to human eids
~/bin/reMap.py cleaned.tsv 1 gene2refseqSimplified_human 3 1 True > t1 
~/bin/reMap.py t1 2 gene2refseqSimplified_human  3 1 True > t2 ## includes fitering out of non-human
head -1 stripped.tsv > header
cat header t2 > $tag.human_direct_GeneID.all.tsv
## $tag.human_direct_GeneID.all.tsv should be all human human interactions in terms of eid
## now filter to one interaction partner being tte
~/bin/keepRows.py $tag.human_direct_GeneID.all.tsv 1 tte.human.eid > hleft.eid 
~/bin/keepRows.py $tag.human_direct_GeneID.all.tsv 2 tte.human.eid > hright.eid 
tail -n +2 hleft.eid > hl.eid
tail -n +2 hright.eid > hr.eid 
cat hl.eid hr.eid | cut -f 1,2 > $tag.human_direct_GeneID.tfcof.tsv

# now map these interactions to mouse eids
~/bin/reMap.py $tag.human_direct.tsv 1 human2mouseGeneID.tsv 2 3 True  >  t5
~/bin/reMap.py t5 2 human2mouseGeneID.tsv 2 3 True  >  $tag.mouse_mappedFromHuman_GeneID.tfcof.tsv
