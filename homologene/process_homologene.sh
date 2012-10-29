#!/bin/bash
wget ftp://ftp.ncbi.nih.gov/pub/HomoloGene/current/homologene.data

python human2mouseHomologene.py homologene.data > tempfile
~/bin/reMap.py tempfile 1 ~/data/ncbi/gene_info_simplified_human 1 2 | awk '{print $1}' > human_symbols
~/bin/reMap.py tempfile 2 ~/data/ncbi/gene_info_simplified_mouse 1 2 | awk '{print $2}' > mouse_symbols
paste human_symbols tempfile mouse_symbols > human2mouseGeneID.tsv 

python human2mouseHomologeneRefSeq.py homologene.data > tempfile
## Mapping from NPs to GeneIDs. Many XP_ are failing. Turn out to be obsolete IDs (shouldn't be in homologene!)
~/bin/reMap.py tempfile 1 ~/data/ncbi/gene2refseqSimplified_human 3 1 | awk '{print $1}' > human_eids
~/bin/reMap.py tempfile 2 ~/data/ncbi/gene2refseqSimplified_mouse 3 1 | awk '{print $2}' > mouse_eids
~/bin/reMap.py human_eids 1 ~/data/ncbi/gene_info_simplified_human 1 2 > human_symbols
~/bin/reMap.py mouse_eids 1 ~/data/ncbi/gene_info_simplified_mouse 1 2 > mouse_symbols
paste human_symbols human_eids tempfile mouse_eids mouse_symbols  > human2mouseRefSeqID.tsv 

rm -f tempfile human_symbols mouse_symbols human_eids mouse_eids
