library(Seurat)
library(dplyr)
library(Matrix)
library(gplots)

load('2018-07-17_7500.RData')
OUT='exp_LigRec_detail.txt'

RL=read.table('ReceptorLigand.txt',header=T,sep='\t')

this_data=mb3076_11@data
this_data=apply(this_data,1,scale)
this_data=t(this_data)
rownames(this_data)=rownames(mb3076_11@data)
colnames(this_data)=colnames(mb3076_11@data)

this_CLUSTER=as.character(mb3076_11@ident)
CNUM=length(table(this_CLUSTER))


ALLINFO=c('Lig','Rec','LigC','RecC','Score')
write.table(t(ALLINFO),file=OUT,sep='\t',quote=F,row.names=F,col.names=F)

rl_row=1
while(rl_row<=length(RL[,1])){
        L=as.character(RL[rl_row,1])
        R=as.character(RL[rl_row,2])
        if(L %in% rownames(this_data) & R %in% rownames(this_data)){
            Lrow= which(rownames(this_data) %in% L)
            Rrow= which(rownames(this_data) %in% R)
            Lexp= this_data[Lrow,]
            Rexp= this_data[Rrow,]
            Lscore=c()
            Rscore=c()
            cluster=0
            while(cluster<=(CNUM-1)){
                in_this_cluster=which(this_CLUSTER %in% as.character(cluster))
                lscore=mean(Lexp[in_this_cluster])
                rscore=mean(Rexp[in_this_cluster])
                Lscore=c(Lscore,lscore)
                Rscore=c(Rscore,rscore)
                cluster=cluster+1}
            Lscore[which(is.na(Lscore))]=0
            Rscore[which(is.na(Rscore))]=0
            #Lrank=(rank(Lscore,ties='min')-1)/length(Lscore)
            #Rrank=(rank(Rscore,ties='min')-1)/length(Rscore)
            rr=1
            while(rr<=length(Rscore)){
                cc=1
                while(cc<=length(Lscore)){
                    thisinfo=c(L,R,cc-1,rr-1, (Rscore[rr]+Lscore[cc])/2)
                    write.table(t(thisinfo),file=OUT,sep='\t',quote=F,row.names=F,col.names=F,append=TRUE)
                    cc=cc+1}
                rr=rr+1}}
        print(rl_row)
        rl_row=rl_row+1}


