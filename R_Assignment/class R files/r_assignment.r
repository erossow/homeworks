#Replicating UNIX assignment in R

#Data Inspection
geno<-read.table("fang_et_al_genotypes.txt", header=T,stringsAsFactors = F)
snp<-read.delim("snp_position.txt",header=T,stringsAsFactors = F)         #ooohhhh it's tab deliminated and not a table/csv......

#"Fang_et_al_genotypes.txt"Inspection
colnames(geno[1:10])
row.names(geno)

#snp_position Inspection
colnames(snp)
row.names(snp) #Rows = SNP_ID

#Extracting Data
maize_geno <- geno[(geno$Group == "ZMMIL")|(geno$Group == "ZMMLR")|(geno$Group =="ZMMMR"),]
teo_geno<- geno[(geno$Group == "ZMPBA")|(geno$Group == "ZMPIL")|(geno$Group == "ZMPJA"),]


snp$Chromosome.f<-as.factor(snp$Chromosome)

nrow(maize_geno)
maize_geno<-sort(geno$Group)
