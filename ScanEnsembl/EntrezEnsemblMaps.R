## load table to with ensembl gene ID and ncbi gene ID mappings, and parse into a list keyed by entrez Gene IDs
## ( Retain only nonzero integer part of ensembl gene ID )

## An Entrez Gene ID may correspond to multiple Ensembl IDs

## 2012 Exciting addendum to this: can be other way around
## ENSMUSG00000003038 is "15331"     "627375"    "671242"    "100503799" Yay!
## Task: spend a few hours exploring the implications of this

gg <- read.table("EnsemblGeneIDtoEntrezGeneID.tsv",sep='\t',header=TRUE,as.is=TRUE)
entrezIDs <- as.character(gg[,"EntrezGene.ID"])
ensidsfull <- gg[,"Ensembl.Gene.ID"]

## Quite a few ENSMUSGS have no Entrez ID (1798 - Oct 2012)
goodinds <- which(!is.na(entrezIDs))
entrezIDs <- entrezIDs[goodinds]
ensidsfull <- ensidsfull[goodinds]

## short version of ensembl ID used for all indexing
ensshort <- function(eg){as.character(as.numeric(substr(eg,8,18)))}
ensids <- as.character(sapply(ensidsfull,ensshort))

entrezIDofEnsemblID <- entrezIDs
names(entrezIDofEnsemblID) <- ensids

# I know there is a more clever way to do this!
ensemblIDsOfEntrezIDs <- list()
for ( eid in unique(entrezIDs) ){
  ens <- ensids[which(entrezIDs==eid)]
  ensemblIDsOfEntrezIDs[[eid]]<- ens
}

save(file='allMouseMappings.RData',entrezIDofEnsemblID,ensemblIDsOfEntrezIDs)
