
## NCBI gene symbols. Create files for mappings to use in R
## gene.symbols: Gene symbols, given a Gene ID
## gene.eids: Gene ID, given a gene symbol
gene.info.mouse <- read.table("gene_info_simplified_mouse",sep="\t",as.is=TRUE)
gene.eid <- as.character(gene.info.mouse$V1)
gene.symbol <- as.character(gene.info.mouse$V2)
names(gene.symbol) <- gene.eid
names(gene.eid) <- gene.symbol
save(gene.symbol,file="gene.symbol.RData")
save(gene.eid,file="gene.eid.RData")

## NCBI gene NP. Create files for mappings to use in R
gene2refseq.mouse <- read.table("gene2refseqSimplified_mouse",sep="\t",as.is=TRUE)
eid <- as.character(gene2refseq.mouse$V1)
np <- as.character(gene2refseq.mouse$V3)

goodinds <- grep("NP",np) ## drop out the XP and blanks
eid <- eid[goodinds]
np <- np[goodinds]
## still multiple redundancies of NPs for each eid.
## Let's choose the first one, using this amazing trick
v <- eid
w <- unique(v)
keepinds <- match(w,v)
eid <- eid[keepinds]
np <- np[keepinds]
names(np) <- eid
save(np,file="np.RData")

## NCBI gene NM. Create files for mappings to use in R
gene2refseq.mouse <- read.table("gene2refseqSimplified_NM_mouse",sep="\t",as.is=TRUE)

eids <- as.character(gene2refseq.mouse$V1)
nms <- as.character(gene2refseq.mouse$V2)

goodinds <- grep("NM",nm) ## drop out others and blanks
eids <- eids[goodinds]
nms <- nms[goodinds]
## can have multiple redundancies of NMs for each eid.
 
eid.of.nm <- eids
names(eid.of.nm) <- nms
save(eid.of.nm,file="eid.of.nm.RData")
 
## NMs for a given Entrez ID
nms.of.eid <- list()
for ( eid in eids ){
  nms.of.eid[[eid]] <- nms[which(eids==eid)]
} 

save(nms.of.eid,file="nms.of.eid.RData")
