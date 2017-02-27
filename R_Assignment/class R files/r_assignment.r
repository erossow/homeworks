#Replicating UNIX assignment in R

### Data Inspection
geno<-read.table("fang_et_al_genotypes.txt", header=T,stringsAsFactors = F)
snp<-read.delim("snp_position.txt",header=T,stringsAsFactors = F)         #ooohhhh it's tab deliminated and not a table/csv......

#"Fang_et_al_genotypes.txt"Inspection
class(geno)
attributes(geno)
colnames(geno[1:10])
row.names(geno)
dim(t(snp))

#snp_position Inspection
class(snp)
colnames(snp)
row.names(snp) #Rows = SNP_ID
attributes(snp)
dim(snp)

### Extracting and Processing Data
maize_geno <- geno[(geno$Group == "ZMMIL")|(geno$Group == "ZMMLR")|(geno$Group =="ZMMMR"),]
teo_geno<- geno[(geno$Group == "ZMPBA")|(geno$Group == "ZMPIL")|(geno$Group == "ZMPJA"),]

#Transpose each of the genotype files
tmaize_geno<- t(maize_geno)
tteo_geno<- t(teo_geno)

#Merge genotype files with snp data
tmaize_joined<- merge(snp, tmaize_geno, by.x = "SNP_ID",by.y = "row.names")
tteo_joined<- merge(snp, tteo_geno, by.x = "SNP_ID",by.y = "row.names")

#Find dimensions of file to extract columns needed
dim(tmaize_joined)
cut_maize<-tmaize_joined[,c(1,3,4,16:1588)]

dim(tteo_joined)
cut_teo<-tteo_joined[,c(1,3,4,16:990)]

#Sort the joined files by snp position.
cut_maize[order(as.numeric(as.character(cut_maize$Position))),]->maize_increasing_snps
cut_maize[order(as.numeric(as.character(cut_maize$Position)),decreasing = T),]->maize_decreasing_snps


cut_teo[order(as.numeric(as.character(cut_teo$Position))),]->teo_increasing_snps
cut_teo[order(as.numeric(as.character(cut_teo$Position)),decreasing=T),]->teo_decreasing_snps

#Changing out '?' for '-' for decreasing position files

maize_dashes <- maize_decreasing_snps
maize_dashes[maize_dashes == "?/?"] <- "-/-"

teo_dashes <- cut_teo
teo_dashes[teo_dashes == "?/?"] <- "-/-"

#Making Folders for the four chromosome sets
dir.create("maize_chr_increasing")
dir.create("maize_chr_decreasing")
dir.create("teosinte_chr_increasing")
dir.create("teosinte_chr_decreasing")

#Extracting data for each chromosome and writing files
for (i in 1:10) {
  maize_chr_loop <- maize_increasing_snps[maize_increasing_snps$Chromosome == i,]
  write.csv(maize_chr_loop, sprintf("maize_chr_increasing/maize_chromosome_%d_increasing_snps", i), row.names = F)
}

for (i in 1:10) {
  maize_chr_loop <- maize_dashes[maize_dashes$Chromosome == i,]
  write.csv(maize_chr_loop, sprintf("maize_chr_decreasing/maize_chromosome_%d_decreasing_snps", i), row.names = F)
}

for (i in 1:10) {
  teo_chr_loop <- teo_increasing_snps[teo_increasing_snps$Chromosome == i,]
  write.csv(teo_chr_loop, sprintf("teosinte_chr_increasing/teosinte_chromosome_%d_increasing_snps", i), row.names = F)
}

for (i in 1:10) {
  teo_chr_loop <- teo_dashes[teo_dashes$Chromosome == i,]
  write.csv(teo_chr_loop, sprintf("teosinte_chr_decreasing/teosinte_chromosome_%d_decreasing_snps", i), row.names = F)
}

