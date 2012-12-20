#!/bin/bash

## hp_ human protein, mp_ mouse protein

cut -f 3 BINARY_PROTEIN_PROTEIN_INTERACTIONS.txt  > t
sed 's/\.[0-9]//g' t > hp_left

cut -f 6 BINARY_PROTEIN_PROTEIN_INTERACTIONS.txt  > t
sed 's/\.[0-9]//g' t > hp_right

paste hp_left hp_right > hp_pp


#
# NP_
#

## Map left interctors to mouse, dicard non-mappable
~/bin/reMap.py hp_pp 1 ~/data/ncbi/homologene/human2mouseRefSeqID.tsv 3 4 True > mp_pp_1
## Map right interctors to mouse, dicard non-mappable
~/bin/reMap.py mp_pp_1 2 ~/data/ncbi/homologene/human2mouseRefSeqID.tsv 3 4 True > HPRD_mousified.tsv 

awk '{FS="\t";print $1,"pp" ,$2}'  HPRD_mousified.tsv >  HPRD_mousified.sif 


#
# Gene ID
#

## Map left interctors to human gene ID , dicard non-mappable
~/bin/reMap.py hp_pp 1 ~/data/ncbi/gene2refseqSimplified_human 3 1 True > hp_pp_1
## Map right interctors to human gene ID , dicard non-mappable
~/bin/reMap.py hp_pp_1 2 ~/data/ncbi/gene2refseqSimplified_human 3 1 True > hp_ee

## Map left interctors to mouse, dicard non-mappable
~/bin/reMap.py hp_ee 1 ~/data/ncbi/homologene/human2mouseRefSeqID.tsv 2 5 True > mp_ee_1
## Map right interctors to mouse, dicard non-mappable
~/bin/reMap.py mp_ee_1 2 ~/data/ncbi/homologene/human2mouseRefSeqID.tsv 2 5 True > HPRD_mousified_geneIDs.tsv 

sort HPRD_mousified_geneIDs.tsv  | uniq > tempfile ; mv -f tempfile HPRD_mousified_geneIDs.tsv

#
# Gene symbol
#

~/bin/reMap.py HPRD_mousified_geneIDs.tsv 1 ~/data/ncbi/gene_info_simplified_mouse 1 2 > mp_gg_1

~/bin/reMap.py mp_gg_1 2 ~/data/ncbi/gene_info_simplified_mouse 1 2 > HPRD_mousified_symbol.tsv

rm -f t hp_left hp_right hp_pp mp_pp_1 mp_gg_1 hp_ee hp_pp_1 mp_ee_1


