
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

## NCBI gene NP and NM. Create files for mappings to use in R
gene2refseq.mouse <- read.table("~/data/ncbi/gene2refseqSimplified_mouse",sep="\t",as.is=TRUE)
eid <- as.character(gene2refseq.mouse$V1)
nm <- as.character(gene2refseq.mouse$V2)
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
