
# ATTEMPTING TO INSTALL ALL OF THE PACKAGES

install.packages('devtools')


path_to_file ='/Users/oliverregele/Desktop/LGO/Classes/Spring20/6.874-DeepLearningLifeSciences/Project/scAi/'

install.packages(path_to_file, type = 'source', rep = NULL) # The path_to_file would represent the full path and file name

library(devtools)
library(scAI)
library(dplyr)
library(cowplot)
library(Rcpp)
library(RcppArmadillo)
library(RcppEigen)
library(NNLM)
library(float)
library(swne)
library(ComplexHeatmap)
library(AUCell)
library(RcisTarget)
library(cisTopic)
library(umap)
library(BiocManager)
library(biomaRt)

install.packages('clang')

install.packages("https://cran.r-project.org/src/contrib/Archive/RcppArmadillo/RcppArmadillo_0.6.100.0.0.tar.gz", repos=NULL, type="source")

install.packages(c('Rcpp', 'RcppArmadillo'))
install.packages('cowplot')
install.packages('dplyr')
install.packages("scAI")
install.packages('NNLM')
install.packages('float')
install.packages('caret')


library(devtools)
install_github('linxihui/NNLM')

devtools::install_github('linxihui/NNLM')
devtools::install_github("yanwu2014/swne")
devtools::install_github("jokergoo/ComplexHeatmap")  
devtools::install_github("aertslab/RcisTarget")
devtools::install_github("aertslab/AUCell")
devtools::install_github("aertslab/cisTopic")  
devtools::install_github("sqjin/scAI")

install.packages("text2vec")
install.packages('umap')
install.packages("BiocManager")
BiocManager::install("biomaRt")

install.packages('R-splitters')
install.packages('groupdata2')
library(caret)
library(groupdata2)
library(scAI)
library(dplyr)
library(cowplot)
install.packages("tibble")
library(tibble)


# Actual workflow
X <- data_A549$data # List of data matrix

rnaAsMatrix = as.matrix(X$RNA)

# Pulling out the data into dataframes
rnaDF = as.data.frame(t(as.matrix(X$RNA)))
Class = labels$Time
rnaDF = cbind(Class, rnaDF)

atacDF = as.data.frame(t(as.matrix(X$ATAC)))

# Merging the data 
dataMergeDf = merge(rnaDF, atacDF, by=0)

# Checking the merged data
dataMergeDf[,1186:1190]

# Upsampling and checking the data
testUpSample = groupdata2::upsample(dataMergeDf, cat_col="Class")
table(testUpSample$Class)

# Sepearating the data and getting it back into the DcG Format somehow
rna_Upsampled_DF = testUpSample[, 1:1187] # Still has class
atac_Upsampled_DF = testUpSample[, -(1:1187)]

rna_Upsampled_DF_noClassOrRowNames = rna_Upsampled_DF[,-(1:2)]
atac_Upsampled_DF_noClassOrRowNames = atac_Upsampled_DF

rowNames = make.names(rna_Upsampled_DF[,1], unique=TRUE)
rownames(rna_Upsampled_DF_noClassOrRowNames) <- rowNames
rownames(atac_Upsampled_DF_noClassOrRowNames) <- rowNames

rna_Upsampled_DF_noClassOrRowNames = t(rna_Upsampled_DF_noClassOrRowNames)
atac_Upsampled_DF_noClassOrRowNames = t(atac_Upsampled_DF_noClassOrRowNames)


# Convert to DcG Format somehow
typeof(rna_Upsampled_DF_noClassOrRowNames)

typeof(X$RNA)
test = Matrix(as.matrix(rna_Upsampled_DF_noClassOrRowNames), sparse = TRUE)

X$RNA = Matrix(as.matrix(rna_Upsampled_DF_noClassOrRowNames), sparse = TRUE)
X$ATAC = Matrix(as.matrix(atac_Upsampled_DF_noClassOrRowNames), sparse = TRUE)

typeof(labels)
typeof(Class)

classLabels = as.data.frame(testUpSample$Class)
rownames(classLabels) <- rowNames

# scAI session 
scAI_outs <- create_scAIobject(raw.data = X)

scAI_outs <- preprocessing(scAI_outs, assay = NULL, minFeatures = 200, minCells = 1,
                           libararyflag = F, logNormalize = F)
scAI_outs <- addpData(scAI_outs, pdata = classLabels, pdata.name = "Time")


# scAI_output_moreK <- run_scAI(scAI_outs, K = 20, nrun = 1, do.fast = TRUE)

# Saving all of the data
write.csv(as.matrix(scAI_output_moreK@norm.data$RNA), "rnaRawClean_upSampled.csv")
write.csv(as.matrix(scAI_output_moreK@norm.data$ATAC), "atacRawClean_upSampled.csv")
write.csv(classLabels, "treatTimelabels_upSampled.csv")

write.csv(scAI_output_moreK@fit$H, "scAi_CellLoad_20Factors_upSampled.csv")
write.csv(scAI_output_moreK@fit$W$RNA, "scAi_GeneLoad_20Factors_upSampled.csv")
write.csv(scAI_output_moreK@fit$W$ATAC, "scAi_LocusLoad_20Factors_upSampled.csv")

