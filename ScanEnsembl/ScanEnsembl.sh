#!/bin/sh
#
# ScanEnsembl.sh - Scan promoters retrieved from Ensembl
#
# Run in desired output directory
# requires BioMart download: 
# Sequences: results_fasta.txt

export CODE_DIR=~/parse_external_data/ScanEnsembl  ## Code and auxiliary files reside here

cp -p ~/data/ncbi/gene_info_simplified_mouse . ## Archive this locally
cp -p ~/data/ncbi/gene2ensembl_simplified_mouse . ## ditto

## generate map file where ensembl ID is unique
$CODE_DIR/UniquifyMapFile.py > EnsemblGeneIDtoEntrezGeneID.tsv

#---------------------------------------
# Prepare mapping files and scanned file
#----------------------------------------
$CODE_DIR/generateFastaFiles.py results_fasta.txt gene_info_simplified_mouse EnsemblGeneIDtoEntrezGeneID.tsv filelist > fastaFileList
sed 's/fasta/gff/g' fastaFileList  > gffFileList
$CODE_DIR/generateFastaFiles.py results_fasta.txt gene_info_simplified_mouse EnsemblGeneIDtoEntrezGeneID.tsv headers > fastaHeaders
mkdir allMouseUpstreamFASTA
cd allMouseUpstreamFASTA
$CODE_DIR/generateFastaFiles.py ../results_fasta.txt ../gene_info_simplified_mouse ../EnsemblGeneIDtoEntrezGeneID.tsv files
#Generate all.fasta, a single big fasta file
cd ..
$CODE_DIR/generateFastaFiles.py results_fasta.txt gene_info_simplified_mouse EnsemblGeneIDtoEntrezGeneID.tsv singlebig

#-------------------------------------------------
#Create ensembl entrez gene id mapping file for R 
#-------------------------------------------------
R --vanilla < $CODE_DIR/EntrezEnsemblMaps.R

#---------------------------------------
# Perform scan, once for each motif
#---------------------------------------
mkdir  scanPerMotif
$CODE_DIR/scanForEachMotif.sh all.fasta $CODE_DIR/q999.recomputed.tsv >& scanForEachMotif.log 
#renice +18 PID

#---------------------------------------
# Generate promoter specific gff files from the per motif scans
#---------------------------------------
mkdir allMouseUpstreamGFF
$CODE_DIR/perGeneFromPerMotif.sh >& perGeneFromPerMotif.logfile 

#---------------------------------------
# Create Parsed gff files
# Extract reduced set of columns from full GFF and convert to relative, upstream coordinates
#---------------------------------------
mkdir allMouseUpstreamParsedGFF
$CODE_DIR/parseWrapper.sh >& parseWrapper.logfile 

#-------------------------------------------------
# Create R version of scans
#-------------------------------------------------
R --no-restore-data --slave < $CODE_DIR/read.parsed.files.R >& read.parsed.files.logfile 

