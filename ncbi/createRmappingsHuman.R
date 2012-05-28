
## NCBI gene symbols. Create files for mappings to use in R
## gene.symbols: Gene symbols, given a Gene ID
## gene.eids: Gene ID, given a gene symbol
sc <- scan("gene_info_simplified_human",what="character",sep="\n")
scc <- sapply(sc,strsplit,split="\t")
gene.eid <- as.character(unlist(lapply(scc,"[[",1)))
gene.symbol <- as.character(unlist(lapply(scc,"[[",2)))
gene.fullname <- as.character(unlist(lapply(scc,"[[",3)))
#gene.info.human <- read.table("gene_info_simplified_human",sep="\t",as.is=TRUE)
#gene.eid <- as.character(gene.info.human$V1)
#gene.symbol <- as.character(gene.info.human$V2)
#gene.fullname <- as.character(gene.info.human$V3)
names(gene.symbol) <- gene.eid
names(gene.eid) <- gene.symbol
names(gene.fullname) <- gene.eid
save(gene.symbol,file="gene.symbol.human.RData")
save(gene.eid,file="gene.eid.human.RData")
save(gene.fullname,file="gene.fullname.human.RData")

## NCBI gene NP. Create files for mappings to use in R
gene2refseq.human <- read.table("gene2refseqSimplified_human",sep="\t",as.is=TRUE)
eid <- as.character(gene2refseq.human$V1)
np <- as.character(gene2refseq.human$V3)

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
save(np,file="np.human.RData")

## NCBI gene NM. Create files for mappings to use in R
gene2refseq.human <- read.table("gene2refseqSimplified_NM_human",sep="\t",as.is=TRUE)

eids <- as.character(gene2refseq.human$V1)
nms <- as.character(gene2refseq.human$V2)

goodinds <- grep("NM",nms) ## drop out others and blanks
eids <- eids[goodinds]
nms <- nms[goodinds]
## can have multiple redundancies of NMs for each eid.
 
eid.of.nm <- eids
names(eid.of.nm) <- nms
save(eid.of.nm,file="eid.of.nm.human.RData")
 
## NMs for a given Entrez ID
nms.of.eid <- list()
for ( eid in eids ){
  nms.of.eid[[eid]] <- nms[which(eids==eid)]
} 

save(nms.of.eid,file="nms.of.eid.human.RData")
