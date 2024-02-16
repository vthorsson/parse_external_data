#!/bin/bash
#
# Update ncbi mappings for mouse and human
#
# Archive previous versions if necessary
# Run from a linux shared machine

## directory in which this script resides
BASEDIR=`dirname $0`

#
# Gene Info
#

wget ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_info.gz 
gunzip gene_info.gz 
awk -F '\t' '{OFS="\t";print $1,$2,$3, $6, $9}' gene_info > gene_info_simplified
grep '^10090\b' gene_info_simplified | awk -F '\t' '{OFS="\t";print $2, $3, $5}' > gene_info_simplified_mouse
grep '^9606\b' gene_info_simplified  | awk -F '\t' '{OFS="\t";print $2, $3, $5}' > gene_info_simplified_human

## Refseq
wget ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2refseq.gz
gunzip gene2refseq.gz 

grep '^10090\b' gene2refseq > gene2refseq_mouse
awk -F '\t' '{OFS="\t";print $2,$4,$6}' gene2refseq_mouse > t1
sed 's/\.[0-9]//g' t1 > t2
sort -n t2 | uniq > t3
mv t3 gene2refseqSimplified_mouse
rm -f t1 t2

awk -F '\t' '{OFS="\t";print $2,$4}' gene2refseq_mouse > t1
sed 's/\.[0-9]//g' t1 > t2
sort -n t2 | uniq > t3
mv t3 gene2refseqSimplified_NM_mouse
rm -f t1 t2

grep '^9606\b' gene2refseq > gene2refseq_human
awk -F '\t' '{OFS="\t";print $2,$4,$6}' gene2refseq_human > t1
sed 's/\.[0-9]//g' t1 > t2
sort -n t2 | uniq > t3
mv t3 gene2refseqSimplified_human
rm -f t1 t2

awk -F '\t' '{OFS="\t";print $2,$4}' gene2refseq_human > t1
sed 's/\.[0-9]//g' t1 > t2
sort -n t2 | uniq > t3
mv t3 gene2refseqSimplified_NM_human
rm -f t1 t2

##
## Mapping to Ensembl 
## 
## Refseq
wget ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2ensembl.gz
gunzip gene2ensembl.gz 
grep '^10090\b' gene2ensembl | awk '{OFS="\t"; print $3,$2}' | sort | uniq  > gene2ensembl_simplified_mouse
grep '^9606\b' gene2ensembl | awk '{OFS="\t"; print $3,$2}' | sort | uniq  > gene2ensembl_simplified_human
## Note that these have redundancies in both directions of the mapping, but most ensembl gene IDs are unique in these files

##
## Human Mouse Orthologs
## 
## 
wget ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_orthologs.gz
gunzip gene_orthologs.gz
mouseOrgID=10090
humanOrgID=9606

grep ^$humanOrgID gene_orthologs  | awk -v r=$mouseOrgID 'BEGIN { FS = "\t"; OFS="\t" } ; { if ($4==r ) print $2, $5}' > human2mouse_1
grep ^$mouseOrgID gene_orthologs  | awk -v r=$humanOrgID 'BEGIN { FS = "\t"; OFS="\t" } ; { if ($4==r ) print $5, $2}' > human2mouse_2
cat human2mouse_1 human2mouse_2 > human2mouse_geneID
python ~/bin/reMap.py  human2mouse_geneID 1 gene_info_simplified_human 1 2 | cut -f 1 > human_symbol
python ~/bin/reMap.py  human2mouse_geneID 2 gene_info_simplified_mouse 1 2 | cut -f 2 > mouse_symbol
paste human2mouse_geneID human_symbol mouse_symbol | awk -v OFS="\t" -F "\t" '{print $3, $1,$4, $2}' > human2mouse
rm -f gene_orthologs human2mouse_1 human2mouse_2 human_symbol mouse_symbol human2mouse_geneID


##
## Mapping files for R
##

## R --vanilla --slave < $BASEDIR/createRmappings.R
## R --vanilla --slave < $BASEDIR/createRmappingsHuman.R

##
## Clean up big files
## 

rm -f gene_info gene_info_simplified
rm -f gene2refseq 
rm -f gene2ensembl
