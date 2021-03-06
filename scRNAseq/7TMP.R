library(Seurat)
library(dplyr)
library(Matrix)
load("./images/Seurat_EXP_TSNE.Robj")
load("./images/Seurat_EXP_cluster.Robj")
vargene_row=which(row.names(EXP_cluster@data) %in% EXP_cluster@var.genes)
OUT=as.matrix(EXP_cluster@data[vargene_row,])
write.table(file='var_gene_data.txt',OUT,sep='\t',quote=F,row.names=T,col.names=T)




library(Seurat)
library(dplyr)
library(Matrix)

PCNUM=40
PCUSE=1:35
RES=2

#a=read.table('var_gene_data.SSN.txt',header=T,row.names=1)
exp_data=read.table('var_gene_data.SSN.txt.uniq.txt',header=T,row.names=1)
exp_data[is.na(exp_data)]=0
EXP = CreateSeuratObject(raw.data = exp_data, min.cells = 3, min.genes=200)
all_gene=row.names(exp_data)
EXP = ScaleData(object = EXP,vars.to.regress = c("nUMI"), genes.use = all_gene)
EXP <- RunPCA(object = EXP, pc.genes = all_gene, do.print = TRUE, pcs.print = 1:5,    genes.print = 5, pcs.compute=PCNUM, maxit = 500, weight.by.var = FALSE )
EXP <- RunTSNE(object = EXP, dims.use = PCUSE, do.fast = TRUE)
EXP_cluster <- FindClusters(object = EXP, reduction.type = "pca", dims.use = PCUSE,  resolution = RES, print.output = 0, save.SNN = TRUE)

save(EXP, file = "SSN_EXP.Robj")
save(EXP_cluster, file = "SSN_EXP_cluster.Robj")

pdf('SSN_Seurat.pdf',width=30,height=15)
TSNEPlot(object = EXP)
TSNEPlot(object = EXP_cluster)
TSNEPlot(object = EXP_cluster,do.label=T)
plot1=TSNEPlot(object = EXP,do.return = T,colors.use=c('grey','grey','grey','grey','grey','red'),plot.order=c('S1.5MD','S1.5MP','S1.5MSN','S4MD','S4MP','S4MSN'))
plot2=TSNEPlot(object = EXP,do.return = T,colors.use=c('grey','grey','grey','grey','grey','red'),plot.order=c('S1.5MP','S1.5MD','S1.5MSN','S4MD','S4MP','S4MSN'))
plot3=TSNEPlot(object = EXP,do.return = T,colors.use=c('grey','grey','grey','grey','grey','red'),plot.order=c('S1.5MSN','S1.5MD','S1.5MP','S4MD','S4MP','S4MSN'))
plot4=TSNEPlot(object = EXP,do.return = T,colors.use=c('grey','grey','grey','grey','grey','red'),plot.order=c('S4MD','S1.5MP','S1.5MSN','S1.5MD','S4MP','S4MSN'))
plot5=TSNEPlot(object = EXP,do.return = T,colors.use=c('grey','grey','grey','grey','grey','red'),plot.order=c('S4MP','S1.5MD','S1.5MSN','S4MD','S1.5MP','S4MSN'))
plot6=TSNEPlot(object = EXP,do.return = T,colors.use=c('grey','grey','grey','grey','grey','red'),plot.order=c('S4MSN','S1.5MD','S1.5MP','S4MD','S4MP','S1.5MSN'))
plot_grid(plot1, plot2,plot3,plot4,plot5,plot6)
dev.off()


SSN_CLUSTER=EXP_cluster@ident


load('../images/Seurat_EXP_cluster.Robj')
OLD_CLUSTER=EXP_cluster@ident
EXP_cluster@ident=SSN_CLUSTER



i=0
while(i<=23){
print(i)
#TSNEPlot(object = EXP_cluster,colors.use=c(rep('grey',i),'red',rep('grey',30-i)))
cluster.markers <- FindMarkers(object = EXP_cluster, ident.1 = i, min.pct = 0.25)
cluser_top = head(x = cluster.markers, n = 1000)
write.table(file=paste0('Cluster_Marker/Cluster_',as.character(i),'_marker.tsv'),cluser_top,sep='\t',quote=F)
i=i+1}









