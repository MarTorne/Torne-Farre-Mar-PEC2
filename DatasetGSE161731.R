
## Descàrrega del dataset GSE161731
# Instal·lem Bioconductor 
if (!require(BiocManager)){
  install.packages("BiocManager",dep=TRUE)}

# Definim la funció installifnot
installifnot<-function(pckgName,BioC=TRUE){
  if (BioC){
    if (!require(pckgName,character.only=TRUE)){
      BiocManager::install(pckgName)}
  } else {
    if (!require(pckgName,character.only=TRUE)){
      install.packages(pckgName,dep=TRUE)}
  }
}

# Carreguem els paquets
installifnot("GEOquery")
installifnot("SummarizedExperiment")
installifnot("EnsDb.Hsapiens.v86")
installifnot("GenomicRanges")
installifnot("AnnotationDbi") # Deixar??
installifnot("org.Hs.eg.db")
installifnot("S4Vectors") # Deixar??
installifnot("DESeq2")
installifnot("Biobase")
installifnot("arrayQualityMetrics")
installifnot("edgeR")
installifnot("factoextra")  # Deixar??
installifnot("limma")
installifnot("ggplot2")
installifnot("VennDiagram")
installifnot("dplyr")
installifnot("UpSetR")
installifnot("grid")
installifnot("clusterProfiler")

# Creem els directoris al repositori
if (!dir.exists("dades")) dir.create("dades")
if (!dir.exists("resultats")) dir.create("resultats")
if (!dir.exists("figures")) dir.create("figures")

# Assignem els directoris de treball a variables
dir_treball<-getwd()
dir_dades<-file.path(dir_treball,"dades")
dir_resultats<-file.path(dir_treball,"resultats")

# Guardem els fitxers al repositori
if (!file.exists(file.path(dir_dades,"GSE161731_counts.csv.gz"))){
  url<-"https://ftp.ncbi.nlm.nih.gov/geo/series/GSE161nnn/GSE161731/suppl/GSE161731%5Fcounts.csv.gz"
  utils::download.file(url,destfile=file.path(dir_dades,"GSE161731_counts.csv.gz"),mode="wb")}
if (!file.exists(file.path(dir_dades,"GSE161731_counts.csv"))){
  R.utils::gunzip(file.path(dir_dades,"GSE161731_counts.csv.gz"))}

if (!file.exists(file.path(dir_dades,"GSE161731_counts_key.csv.gz"))){
  url<-"https://ftp.ncbi.nlm.nih.gov/geo/series/GSE161nnn/GSE161731/suppl/GSE161731%5Fcounts%5Fkey.csv.gz"
  utils::download.file(url,destfile=file.path(dir_dades,"GSE161731_counts_key.csv.gz"),mode="wb")}
if (!file.exists(file.path(dir_dades,"GSE161731_counts_key.csv"))){
  R.utils::gunzip(file.path(dir_dades,"GSE161731_counts_key.csv.gz"))}

if (!file.exists(file.path(dir_dades,"GSE161731_key.csv.gz"))){
  url<-"https://ftp.ncbi.nlm.nih.gov/geo/series/GSE161nnn/GSE161731/suppl/GSE161731%5Fkey.csv.gz"
  utils::download.file(url,destfile=file.path(dir_dades,"GSE161731_key.csv.gz"),mode="wb")}
if (!file.exists(file.path(dir_dades,"GSE161731_key.csv"))){
  R.utils::gunzip(file.path(dir_dades,"GSE161731_key.csv.gz"))}


## Construcció de l'objecte SummarizedExperiment
# Obtenim l'estudi GEO
#gse<-getGEO("GSE161731",GSEMatrix=TRUE)

# Revisem la informació que conté cada fitxer
counts<-read.csv(file.path(dir_dades,"GSE161731_counts.csv.gz"),row.names=1,check.names=FALSE)
counts_key<-read.csv(file.path(dir_dades,"GSE161731_counts_key.csv.gz"))
meta<-read.csv(file.path(dir_dades,"GSE161731_key.csv.gz"))
#head(counts_key)
#head(meta)
#colnames(counts_key)
#colnames(meta)
table(duplicated(counts_key$rna_id)) # Comprovem si hi ha rna_id duplicades
table(duplicated(counts_key$subject_id)) # Comprovem si hi ha subject_id duplicats
#table(counts_key$subject_id)

# Revisem que les dimensions dels fitxers permetin construïr el SummarizedExperiment
rownames(counts_key)<-counts_key$rna_id
all(colnames(counts) %in% rownames(counts_key)) # Comprovem que coincideixen
setdiff(colnames(counts),rownames(counts_key))

# Comprovem si les mostres amb sufix _batch2 es corresponen a identificadors que ja existeixen
mostres_batch2<-c("DU09-02S0000150_batch2","DU09-02S0000154_batch2","DU09-02S0000158_batch2")
mostres_batch2_suprimides<-gsub("_batch2","",mostres_batch2)
resultats<-mostres_batch2_suprimides %in% colnames(counts)
resultats
counts<-counts[,!colnames(counts) %in% c("DU09-02S0000150_batch2","DU09-02S0000154_batch2","DU09-02S0000158_batch2")] # Eliminem les 3 mostres

# Construïm l'objecte SummarizedExperiment
SE_GSE161731<-SummarizedExperiment(assays=list(counts=as.matrix(counts)),colData=DataFrame(counts_key))
SE_GSE161731

# Agreguem les coordenades gèniques
coord_gens<-genes(EnsDb.Hsapiens.v86,filter=GeneIdFilter(rownames(SE_GSE161731)))
#rowRanges(SE_GSE161731)<-coord_gens # No funciona. Tenim 60675 files a la matriu d'expressió i 57602 gens 
gens_comuns<-intersect(rownames(SE_GSE161731),coord_gens$gene_id) # Seleccionem els gens amb coordenades disponibles
SE_GSE161731<-SE_GSE161731[gens_comuns,] # Subconjunt de la matriu d'expressió i les coordenades coincidents
coord_gens_filtrat<-coord_gens[match(gens_comuns,coord_gens$gene_id)]
rowRanges(SE_GSE161731)<-coord_gens_filtrat # Assignem les rowRanges

# Gravem l'objecte SummarizedExperiment
saveRDS(SE_GSE161731,file=file.path(dir_resultats,"DatasetGSE161731.rds"))
SE_GSE161731


## Neteja de les dades i selecció de mostres
# Seleccionem les cohorts: COVID19, Bacterial i healthy
rna_ids_sel<-counts_key$rna_id[counts_key$cohort %in% c("COVID-19","Bacterial","healthy")]
SE_GSE161731<-SE_GSE161731[,colnames(SE_GSE161731) %in% rna_ids_sel]
table(colData(SE_GSE161731)$cohort)

# Eliminem els subject_id duplicats
counts_key_sense_dup<-counts_key[!duplicated(counts_key$subject_id),]
rna_ids_sense_dup<-counts_key_sense_dup$rna_id
SE_GSE161731<-SE_GSE161731[,colnames(SE_GSE161731) %in% rna_ids_sense_dup]
table(duplicated(counts_key_sense_dup$subject_id))  # Ha de donar FALSE
dim(SE_GSE161731)
ncol(SE_GSE161731)
SE_GSE161731

# Definim el format de les variables i eliminem els caràcters especials
counts_key$age<-as.numeric(counts_key$age)
counts_key$gender<-as.factor(counts_key$gender)
levels(counts_key$gender)
counts_key$race<-gsub("[ /-]","_",counts_key$race)
counts_key$race<-as.factor(counts_key$race)
levels(counts_key$race)
counts_key$cohort<-as.factor(counts_key$cohort)
levels(counts_key$cohort)
counts_key$time_since_onset<-as.factor(counts_key$time_since_onset)
levels(counts_key$time_since_onset)
counts_key$hospitalized<-as.factor(counts_key$hospitalized)
levels(counts_key$hospitalized)
counts_key$batch<-as.factor(counts_key$batch)
levels(counts_key$batch)
str(counts_key)

# Seleccionem 75 mostres utilitzant una llavor determinada
myseed<-sum(utf8ToInt("martornefarre"))
set.seed(myseed)
mostres_sel<-sample(colnames(SE_GSE161731),75)
#mostres_sel
SE_GSE161731<-SE_GSE161731[,colnames(SE_GSE161731) %in% mostres_sel]
dim(SE_GSE161731)
SE_GSE161731


## Pre-processat inicial de les dades
### Filtrat de gens amb baixa expressió
# Expresem el comptatges en CPM i els seleccionem segons criteri
cpm_matriu<-cpm(assay(SE_GSE161731))
gens_guardats<-rowSums(cpm_matriu>0.5)>=2 # Seleccionem els gens amb cpm>0.5 en almenys 2 mostres
SE_GSE161731<-SE_GSE161731[gens_guardats,] # Apliquem el filtratge a l'objecte SummarizedExperiment
SE_GSE161731


### Normalització dels comptatges per profunditat de seqüenciació
# Normalitzem els comptatges bruts per les diferents profunditats de secuenciació per cada mostra
dds<-DESeqDataSet(SE_GSE161731,design=~1)
dds<-estimateSizeFactors(dds) # Estimem els factors de normalització 
vst<-vst(dds) # Apliquem una transformació de variància estabilitzada
assay(SE_GSE161731,"vst_counts")<-assay(vst) # Afegim la matriu normalitzada com un nou assay
assayNames(SE_GSE161731)


### Control de qualitat de les dades normalitzades
# Control de qualitat de les dades pre-processades i normalitzades 
counts_vst<-assay(SE_GSE161731,"vst_counts")
pheno_dades<-AnnotatedDataFrame(as.data.frame(colData(SE_GSE161731))) # Convertim les metadades en un objecte AnnotatedDataFrame
eset<-ExpressionSet(assayData=counts_vst,phenoData=pheno_dades) # Creem un objecte ExpressionSet amb els comptatges i metadades
arrayQualityMetrics(eset,outdir="AQM_resultats",force=TRUE) # Apliquem el control de qualitat


## Anàlisi exploratòria de les dades transformades/normalitzades
### Identificació i eliminació de mostres atípiques
# Boxplot dels recomptes no normalitzats
dgeObj<-DGEList(counts=assay(SE_GSE161731,"counts")) # Creem un objecte DGEList amb els comptatges originals
logcounts<-cpm(dgeObj,log=TRUE) # Calculem els valors CPM en escala log2
boxplot(logcounts,ylab="Log2-CPM",las=2,xlab="",cex.axis=0.5,main="Boxplots of logCPMs (unnormalised)",cex.main=0.8) # Representem el boxplot
abline(h=median(logcounts),col="blue") # Afegim una línia horitzontal amb la mediana global
dim(logcounts)

# Identifiquem els outliers
colnames(logcounts)[which.min(apply(logcounts,2,median))] # Identifiquem la mostra amb la mediana més baixa de logCPM
#logcounts[,"94478"]
#counts[,"94478"]
#hist(logcounts[,"94478"],breaks=50,main="Distribució logCPM per la mostra 94478",xlab="log2-CPM")
#summary(logcounts[,"94478"])
#summary(logcounts[,"94189"])

# Eliminem la mostra outlier detectada ("94478") de totes les matrius i objectes
cpm_matriu<-cpm_matriu[,colnames(cpm_matriu)!="94478"]
vst<-vst[,colnames(vst)!="94478"]
dgeObj<-dgeObj[,colnames(dgeObj)!="94478"]
logcounts<-logcounts[,colnames(logcounts)!="94478"]
SE_GSE161731<-SE_GSE161731[,colnames(SE_GSE161731)!="94478"]
SE_GSE161731 # Verifiquem que la mostra s'ha eliminat

# Boxplot dels recomptes no normalitzats
dgeObj<-DGEList(counts=assay(SE_GSE161731,"counts")) # Creem un objecte DGEList amb els comptatges originals
logcounts<-cpm(dgeObj,log=TRUE) # Calculem els valors CPM en escala log2
boxplot(logcounts,ylab="Log2-CPM",las=2,xlab="",cex.axis=0.5,main="Boxplots of logCPMs (unnormalised)",cex.main=0.8) # Representem el boxplot
abline(h=median(logcounts),col="blue") # Afegim una línia horitzontal amb la mediana global
dim(logcounts)


## Anàlisi  de components principals
# Anàlisi de components principals amb els valors normalitzats
pca_dades<-plotPCA(vst,intgroup="cohort",returnData=TRUE)
percentVar<-round(100*attr(pca_dades,"percentVar")) # Calculem el percentatge de variància explicada per cada component
ggplot(pca_dades,aes(PC1,PC2,color=cohort,label=name))+ # Representem el gràfic
  geom_point(size=3)+
  geom_text(vjust=-0.5,size=3)+
  xlab(paste0("PC1:",percentVar[1],"% variance")) +
  ylab(paste0("PC2:",percentVar[2],"% variance")) +
  theme_minimal()

# Clustering jeràrquic (heatmap)
sampleDists<-dist(t(assay(vst))) # Calculem la distància euclidiana entre mostres a partir dels valors VST
sampleDistMatrix<-as.matrix(sampleDists) # Convertim la matriu de distàncies a un objecte per al heatmap
heatmap(as.matrix(sampleDists),cexRow=0.6,cexCol=0.6) # Visualitzem el heatmap 

# Identifiquem possibles mostres atípiques a partir de la distància a la mitjana de la PCA
pca_dades$distance<-sqrt((pca_dades$PC1-mean(pca_dades$PC1))^2+(pca_dades$PC2-mean(pca_dades$PC2))^2)
threshold<-mean(pca_dades$distance)+2*sd(pca_dades$distance) # Definim el llindar com la mitjana més 2 desviacions estàndard
outliers<-pca_dades[pca_dades$distance>threshold,] # Identifiquem les mostres que superen el llindar
possibles_outliers<-rownames(outliers)
possibles_outliers
#vsd<-vsd[,!colnames(vsd) %in% possibles_outliers]
#SE_GSE161731<-SE_GSE161731[,!colnames(SE_GSE161731) %in% possibles_outliers]
#SE_GSE161731


## Identificació de possibles variables confusores
# PCA de les dades transformades per gender
pca_data<-plotPCA(vst,intgroup=c("cohort","gender"),returnData=TRUE)
percentVar<-round(100*attr(pca_data,"percentVar"))
ggplot(pca_data,aes(PC1,PC2,color=gender))+
  geom_point(size=3)+
  xlab(paste0("PC1: ",percentVar[1],"%"))+
  ylab(paste0("PC2: ",percentVar[2],"%"))+
  coord_fixed()+
  theme_minimal()

# PCA de les dades transformades per race
pca_data<-plotPCA(vst,intgroup=c("cohort","race"),returnData=TRUE)
percentVar<-round(100*attr(pca_data,"percentVar"))
ggplot(pca_data,aes(PC1,PC2,color=race)) +
  geom_point(size=3)+
  xlab(paste0("PC1: ",percentVar[1],"%"))+
  ylab(paste0("PC2: ",percentVar[2],"%"))+
  coord_fixed()+
  theme_minimal()

# PCA de les dades transformades per time_since_onset 
pca_data<-plotPCA(vst,intgroup=c("cohort","time_since_onset"),returnData=TRUE)
percentVar<-round(100*attr(pca_data,"percentVar"))
ggplot(pca_data,aes(PC1,PC2,color=time_since_onset)) +
  geom_point(size=3)+
  xlab(paste0("PC1: ",percentVar[1],"%"))+
  ylab(paste0("PC2: ",percentVar[2],"%"))+
  coord_fixed()+
  theme_minimal()

# PCA de les dades transformades per hospitalized
pca_data<-plotPCA(vst,intgroup=c("cohort","hospitalized"),returnData=TRUE)
percentVar<-round(100*attr(pca_data,"percentVar"))
ggplot(pca_data,aes(PC1,PC2,color=hospitalized)) +
  geom_point(size=3)+
  xlab(paste0("PC1: ",percentVar[1],"%"))+
  ylab(paste0("PC2: ",percentVar[2],"%"))+
  coord_fixed()+
  theme_minimal()

# PCA de les dades transformades per batch
pca_data<-plotPCA(vst,intgroup=c("cohort","batch"),returnData=TRUE)
pca_data$batch<-factor(pca_data$batch)
ggplot(pca_data,aes(PC1,PC2,color=batch)) +
  geom_point(size=3)+
  xlab(paste0("PC1: ",percentVar[1],"%"))+
  ylab(paste0("PC2: ",percentVar[2],"%"))+
  coord_fixed()+
  theme_minimal()

# Categories de les variables respecte cohort
table(colData(SE_GSE161731)$cohort,colData(SE_GSE161731)$race)
table(colData(SE_GSE161731)$cohort,colData(SE_GSE161731)$gender)
table(colData(SE_GSE161731)$cohort,colData(SE_GSE161731)$time_since_onset)
table(colData(SE_GSE161731)$cohort,colData(SE_GSE161731)$hospitalized)
table(colData(SE_GSE161731)$cohort,colData(SE_GSE161731)$batch)


## Construcció de la matriu del disseny i ajust del model
# Establim la llavor per triar el mètode aleatori
myseed<-sum(utf8ToInt("martornefarre"))
set.seed(myseed)
metode<-sample(c("edgeR","voom+limma","DESeq2"),size=1)
cat("Mètode seleccionat:",metode)

# Creem l'objecte DESeqDataSet indicant el model de disseny i ajustem el model
dds<-DESeqDataSet(SE_GSE161731,design=~cohort+race+batch)
dds<-DESeq(dds)
resultsNames(dds)  # Mostrem els contrasts disponibles

# Extraiem els resultats dels contrastos d'interès
res_bacterial<-results(dds,contrast=c("cohort","Bacterial","healthy"))
res_bacterial
res_covid<-results(dds,contrast=c("cohort","COVID-19","healthy"))
res_covid

# Seleccionem els gens significatius
res_bacterial_sig<-res_bacterial[which(res_bacterial$padj<0.05 & abs(res_bacterial$log2FoldChange)>1.5),]
res_bacterial_sig
nrow(res_bacterial_sig)
res_covid_sig<-res_covid[which(res_covid$padj<0.05 & abs(res_covid$log2FoldChange)>1.5),]
res_covid_sig
nrow(res_covid_sig)


## Comparació dels resultats dels contrastos
# Venn per comparar gens diferencialment expressats entre les dues condicions
grafic_venn<-venn.diagram(x=list(COVID=rownames(res_covid_sig),Bacterial=rownames(res_bacterial_sig)),
                          filename=NULL,
                          fill=c("steelblue","tomato"),
                          alpha=0.5,
                          cex=2,
                          cat.cex=1.5,
                          cat.dist=c(0.02,0.02),
                          cat.pos=c(-10,10))
grid.newpage()  
grid.draw(grafic_venn)

# UpSet plots per comparar gens diferencialment expressats entre les dues condicions
llista_gens<-list(
  COVID19=rownames(res_covid_sig),
  Bacterial=rownames(res_bacterial_sig))
fromList(llista_gens) %>% upset(order.by="freq")


### Enriquiment funcional GO dels gens sobreexpressats en la infecció per COVID-19
# Anàlisi d'enriquiment funcional (GO-Biological Process) per als gens diferencialment expressats a COVID-19
gens_covid<-rownames(res_covid_sig)
ego<-enrichGO(
  gene         =gens_covid,
  OrgDb        =org.Hs.eg.db,
  keyType      ="ENSEMBL",
  ont          ="BP",
  pAdjustMethod="BH",
  qvalueCutoff =0.05)
as.data.frame(ego)


### Replicació de l'anàlisi amb un  mètode alternatiu
# Definim la matriu de disseny
matriu_diseny<-model.matrix(~0+cohort+race+batch,data=colData(SE_GSE161731))

# Definim els contrastos
colnames(matriu_diseny)<-make.names(colnames(matriu_diseny))
colnames(matriu_diseny)
matriu_contrast<-makeContrasts(Bacterial_vs_Healthy=cohortBacterial-cohorthealthy,
                               COVID_vs_Healthy=cohortCOVID.19-cohorthealthy,
                               levels=matriu_diseny)
matriu_contrast

# Apliquem voom i ajustem el model
v<-voom(assay(SE_GSE161731,"counts"),matriu_diseny,plot=TRUE)
fit<-lmFit(v,matriu_diseny)
fit2<-contrasts.fit(fit,matriu_contrast)
fit2<-eBayes(fit2)

# Extraiem els resultats dels contrastos d'interès i filtrem
res_bacterial<-topTable(fit2,coef="Bacterial_vs_Healthy",number=Inf,adjust.method="BH")
res_bacterial_sig<-res_bacterial[which(res_bacterial$adj.P.Val < 0.05 & abs(res_bacterial$logFC) > 1.5),]
nrow(res_bacterial_sig)
res_covid<-topTable(fit2,coef="COVID_vs_Healthy",number=Inf,adjust.method="BH")
res_covid_sig<-res_covid[which(res_covid$adj.P.Val < 0.05 & abs(res_covid$logFC) > 1.5),]
nrow(res_covid_sig)

# Venn per comparar gens diferencialment expressats entre les dues condicions
grafic_venn<-venn.diagram(x=list(COVID=rownames(res_covid_sig),Bacterial=rownames(res_bacterial_sig)),
                          filename=NULL,
                          fill=c("steelblue","tomato"),
                          alpha=0.5,
                          cex=2,
                          cat.cex=1.5,
                          cat.dist=c(0.02,0.02),
                          cat.pos=c(-10,10))
grid.newpage()  
grid.draw(grafic_venn)

# UpSet plots per comparar gens diferencialment expressats entre les dues condicions
llista_gens<-list(
  COVID19=rownames(res_covid_sig),
  Bacterial=rownames(res_bacterial_sig))
fromList(llista_gens) %>% upset(order.by="freq")

# Anàlisi d'enriquiment funcional (GO-Biological Process) per als gens diferencialment expressats a COVID-19
gens_covid<-rownames(res_covid_sig)
ego<-enrichGO(
  gene         =gens_covid,
  OrgDb        =org.Hs.eg.db,
  keyType      ="ENSEMBL",
  ont          ="BP",
  pAdjustMethod="BH",
  qvalueCutoff =0.05)
as.data.frame(ego)
