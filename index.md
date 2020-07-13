---
layout: default
title: 'Overview'
---


### Overview
Multimodal single-cell datasets are a recent development that provide numerous opportunities for the application of advanced machine learning techniques. In this work we evaluate the informative value of unimodal and multimodal single-cell datasets in a cell-state classification task on the scRNA-seq and scATAC-seq output of the sci-CAR method applied to dexamethasone treated lung adenocarcinoma-derived A549 cells. We developed a neural net classifier and tested its accuracy on unimodal, Early Fusion Bimodal and scAI Bimodal integrations of the single-cell datasets to evaluate their informative content. This study also performs a novel application of Sufficient Input Subsets to determine modality informativeness as well as identify differentially-expressed genes. While we conclude that multimodal inputs do not provide additional informative content over unimodal scRNA-seq data, SIS was found to be a promising novel method of marker gene identification.


### Motivation
Leveraging multiple single-cell modalities may allow for better classification of cells by their cell type or cell state. Understanding how to classify cells is crucial to large-scale consortiums like the [Human Cell Atlas](https://www.humancellatlas.org/), [HUBMAP](https://commonfund.nih.gov/hubmap), and the [Cell Census Network](https://braininitiative.nih.gov/brain-programs/cell-census-network-biccn), among others.  Much work is still required, however, in using multi-modal techniques for improving classification.

### Problem Statement



### Contributions - maybe remove this part b/c it's redundant with the Overview Section
In this work we were able to explore a number of novel applications of machine learning to single-cell omics data.
- We evaluated the application of neural networks to unimodal and multimodal single-cell data 
- We adding the interpretability of Sufficient Input Subsets to determine relevant informativeness of single-cell omis data features. 
- We explored the value of Feature-Selection and Class-Balancing of the single-cell omics data 
- We show that bimodal inputs may not have any additional advantage over training on sc-RNA-seq alone
- Finally, SIS was also explored as a novel method of identifying marker or differentially-expressed genes of cell state





In this work, we show how multimodal single-cell data can be combined to improve cell-state classification in a deep learning framework. We focus on classifying lung adenocarcinoma-derived A549 cells that have been treated with dexamethasone (DEX), a synthetic compound similar to cortisol, for varying amounts of time \cite{sci-CAR}. This dataset contains gene expression (sc-RNA-seq) and chromatin accessibility (sc-ATAC-seq) data from the same 4,825 cells. We show that both modalities together improve classification of cells by DEX-treatment time. We show how a variety of preprocessing and early-fusion modality integration methods change classification performance; regardless of the preprocessing method applied, bimodal inputs do not outperform unimodal inputs on cell-state identification, instead they tended to perform on-par with sc-RNA-seq unimodal inputs. 

Additionally, we aimed to know how informative each modality is in classification. While both modalities play roles in improving classification, features from sc-RNA-seq are more informative than features from sc-ATAC-seq in cell-state classification. We show the first use of Sufficient Input Subsets (SIS) \cite{SIS} identifying sc genomic features -- unimodal and bimodal -- that lead to classification of cells classified with high confidence (HC).  We investigate how SIS might be useful in determining which modality is the most informative. Lastly, we use SIS on sc-RNA-seq data to understand whether SIS can be used for identifying marker genes and differentially-expressed genes, validating our findings using the original paper that developed sci-CAR \cite{sci-CAR}. 


### Smummary of Results

### Feature selection and class balancing improve classification performance

One aim of this study was to determine the effect on the classifier accuracy of the feature selection methodology applied to the dataset in a previous study \cite{scAI} as well as the class-balancing this work implemented. From Table \ref{accuracy_table} we can determine that both Feature Selection and Class Balancing improved the classifier accuracy. 

The classifier accuracy on cell-type identification on the raw ATAC-seq improved from 74.3\% to 75.5\% with feature selection. With RNA-seq the accuracy improved from 77.6\% to 96.4\%. Early Fusion, concatenated Bimodal data saw similar levels of accuracy improvement, from 80\% to 96.0\%. These results show the efficacy of feature selection in driving neural net classifier accuracy. This is an expected outcome as the feature selection method was designed select the genes and loci that are differentially expressed between the cell groups. However it is interesting that the feature selection seems to drive larger accuracy improvements in the analyses involving RNA-seq data. One possible explanation is that the mRNA expression is more differentially expressed between hours of DEX treatment than chromatin accessibility loci, another is that the sparsity of ATAC-seq data affects the ability of the feature selection method to identify significantly differentiated loci. 



In addition to Feature Selection, correcting the imbalanced classes via upsampling also produced an improvement in classifier accuracy across all datasets. The accuracy between imbalanced and balanced datasets can be seen in Table \ref{tab:ClassAcc}. While performing class balancing produced slight benefits on the datasets that already contained the RNA-seq information, it produced larger increases in accuracy on the ATAC-seq data. One interpretation of this finding is that the differential features between classes are less pronounced in ATAC-sec data. Another is that the class-balancing is better able to express differentiating features in ATAC-sec data than the previous feature selection method. \\

These findings show the value of performing feature selection as well as class balancing on single-cell omics data before use in neural network architectures. According to these findings, the feature selection process was better able to improve the informative content of RNA-seq compared to ATAC-seq. While Class-Balancing was able to produce a larger increase in accuracy for classifiers working with ATAC-seq data compared to datasets with RNA-seq data, it is important to note this was after Feature Selection was already performed. It is possible that the informative content in RNA-seq had already been maximized so that Class-Balancing was unable to add significantly more to it. \\


#### Early Fusion Bimodal inputs outperform scAI Multimodal Integration but perform similarly to RNA-seq inputs

This study explored the value of creating multimodal representations of single-cell omics data in a neural net classification task. Table \ref{accuracy_table} shows the accuracy of classifier on the different datasets. One method of multimodal integration we evaluated was Early Fusion Bimodal, which involved the concatenation of the unimodal data. We find that Bimodal concatenation fails to consistently outperform the RNA-seq data. The classifier run on the Early Fusion Bimodal datasets outperform the RNA-seq data for the non-feature-selected datasets and the low-dimensional representation of the data, however the improvement is small, 2.6\% and 1.5\% difference, respectively. In all other cases the RNA-seq dataset outperforms the Bimodal concatenation dataset. This seems to imply that the majority of the informative content is present in the mRNA expression and that there is only slightly more information provided by the inclusion of the ATAC-seq data into the Bimodal representation. These results indicate that RNA-seq may be informative enough to use for cell-type identification unimodally rather than leveraging bimodal representations. \\

This work also compared the relatively simple Early Fusion Bimodal representations with the novel, complex scAI multimodal integration method designed for integrating single cell RNA-seq and ATAC-seq data. However, on the Class-Balanced datasets for both the Raw Data and the Low-Dimensional Data, the classifier accuracy for the Bimodal Datasets, 96.5\% for the Bimodal Raw Data concatenation and 95.5\% for the Bimodal Low-Dimensional concatenation, far outperforms that of the scAI Integration output, 55.6\%. Despite the complex learning methods employed by scAI in order to integrate multiple single cell-omics modalities and represent them lower dimensionally, the outputs seem ill-suited for cell-type classification via neural nets. Instead a computationally simpler method such as Early Fusion may be more optimal for neural net applications. \\

#### RNA-seq is more informative than ATAC-seq in cell-type identification

% RNA-seq is more informative
We aimed to know which of the two modalities was more informative for classifying cells by cell state (i.e. amt of time treated with DEX). We provide two supporting pieces of evidence that RNA-seq is more informative for this classification task. The first is that models trained only on RNA-seq data performed better under every type of pre-processing, feature selection, and dimensionality-reduction method we applied equally to both modalities.  Table \ref{accuracy_table} shows the test accuracies of each model trained on a variety of data processing methods. In every case, models trained only on RNA-seq performed better than models trained only on ATAC-seq, suggesting that RNA-seq is better equipped to identify A549 cells by their cell state in this experimental context. \\ 

The second supporting evidence comes from analyzing the features that were most important for classification.  We found all Sufficient Input Subsets of features for each cell classified with high confidence ($P(class | data) \geq 0.7$). Given these disjoint subsets, we computed the percent of high-confident (HC) cells  that relied on each feature for each of the three classes (0 hr, 1 hr, & 3 hrs). Table \ref{sis-features} ranks these features and colors the feature name by the modality it came from. It's evident that features from RNA-seq are most needed to classify HC cells treated with DEX for 0 hrs and 3 hrs. Features generated from the ATAC-seq modality were most necessary to classify HC cells treated for 1 hr, yet most subsets also relied on features from RNA-seq as well. Together, this implies that features from both RNA-seq and ATAC-seq are necessary for classifying by cell state, yet RNA-seq is largely more informative than ATAC-seq for this classification task. \\



% RNA-seq may capture much of the same information important for cell-type classification
It's important to note that these results come from a concatenation of the lower-dimensional versions of two very high-dimensional datasets. Because this dataset relies entirely on the principal components of RNA-seq and the singular vectors from ATAC-seq, it's difficult to know exactly which mRNA and chromatin sites are most needed to determine cell state. It's possible that the most important features from each modalities actually represent the same biological features inside these cells.  However, our computational resources precluded us from using SIS on the high-dimensional versions of these modalities to know this. We leave another SIS analysis on high-dimensional RNA-seq and ATAC-seq for a future work. \\


#### SIS may be a useful alternative method to finding marker or DE genes}

Using the SIS method to understand which features most contribute to cell-state classification naturally raised the question of whether SIS could find marker genes and differentially-expressed genes. We found the sufficient input subsets after training our neural network on sc-RNA-seq features only, following feature selection (1185 features in total). Similarly to the previous section, we found the percent of high-confidence cells that rely on each of the features found in at least one subset.  We then compared the expressed genes found using SIS with those found in the original paper that introduced the sci-CAR method. SIS found one gene (NFKBIA) that was named a marker gene in DEX-treated cells. A vast majority of the genes found in SIS were also classified as differentially-expressed genes. 

Table \ref{tab:marker-genes} summarizes these results for HC cells classified as treated for 0 hr and 1 hr. No subsets were found for HC cells classified as 3 hr, preventing us from finding any additional marker genes beyond NFKBIA. 

### TODO - include table here? 







### Acknowledgment
We'd like to thank Professors Gifford and Kellis as well as the incredibly helpful teaching assistants Sachit, Tim, and Corban for teaching us many of the concepts needed to complete this project.

